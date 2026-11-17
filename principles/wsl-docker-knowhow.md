# WSL と Docker のノウハウ（この Windows 機で実験環境を動かす）

3 回のケーススタディで、OpenSearch（RAG）、検索サービスと GPU のモデル（RAG・AgentOps）、Keycloak と Postgres（JWT）を WSL2 の中の Docker で動かした。ここには、実際に使った構成、つまずきと直し方、メモリとディスクの扱いを書く。記録から確定できなかったことは「(要確認)」と付けた。

## 1. 構成の全体像

| 層 | 中身 | 備考 |
| --- | --- | --- |
| Windows 11 | Git Bash（Claude Code の Bash）、PowerShell、Office（COM で PDF 化）、Windows 側の Python（実験の採点・集計、`claude -p` の起動） | 物理メモリ 32 GB、GPU は RTX 4060（8 GB） |
| WSL2 のディストリ | `Ubuntu-24.04`。仮想ディスクの置き場所は E: 上（`E:\wsl\Ubuntu-24.04`） | ルートの ext4 は 1007G の可変長。実使用は 32 GB → 74 GB に増えた |
| Docker | **WSL のディストリの中の Docker Engine**（`/usr/bin/docker`、29.x）。データは `/var/lib/docker`（＝ E: 上の仮想ディスクの中） | Docker Desktop は使わない（下記） |
| GPU | WSL から `nvidia-smi` で見え、PyTorch（cu124 の wheel）で `torch.cuda.is_available()` が True | OCR（YomiToku）と埋め込み・再ランキングのモデルに使った |

### Docker Desktop は使わない

- Windows の Git Bash で `docker info` を打つと `failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine` になる（Docker Desktop は起動していない）。
- `docker-desktop` というディストリは登録されているが停止状態。そのデータの仮想ディスク（`%LOCALAPPDATA%\Docker\wsl\disk\docker_data.vhdx`、約 5.9 GB）は **C: にある**。C: が逼迫しているので、Docker Desktop を起動して使うと C: を消費する。
- だから **Docker は常に `wsl -d Ubuntu-24.04 -- docker ...` で WSL の中のものを使う**。

## 2. ディストリの場所と状態を確かめる

```bash
# 一覧（出力は UTF-16LE なので変換する）
wsl -l -v | iconv -f utf-16le -t utf-8

# 各ディストリの仮想ディスクの置き場所（レジストリの BasePath）
powershell -NoProfile -c "Get-ChildItem 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss' | ForEach-Object { (Get-ItemProperty \$_.PSPath).DistributionName + ' => ' + (Get-ItemProperty \$_.PSPath).BasePath }"

# 中の資源とディスク
wsl -d Ubuntu-24.04 -- bash -lc 'free -g | head -2; nproc; docker info --format "{{.ServerVersion}} {{.DockerRootDir}}"; df -h / /mnt/e | tail -2; nvidia-smi --query-gpu=name,memory.used --format=csv'
```

- WSL の `free -g` では合計が 9 GB 前後に見えた（ホストは 32 GB）。`.wslconfig` でメモリの上限を決めているのか、既定の動的割り当ての見え方なのかは記録に無い (要確認)。
- ディストリを E: に移した手順は、この回の記録には無い（既に E: にあった）。一般的には `wsl --export` → `wsl --unregister` → `wsl --import <名前> E:\wsl\<名前> <tar>`、または新しい WSL の `wsl --manage <名前> --move <場所>` を使う (要確認：この機でどちらを使ったか、既定ユーザーの再設定が要るか)。
- WSL の中で Docker デーモンがどう起動しているか（systemd か、手動の `dockerd` か）は記録に無い。`docker info` は最初から通った (要確認)。

## 3. Windows（Git Bash）から WSL を呼ぶときの落とし穴

### パスの変換：`MSYS_NO_PATHCONV=1` を付ける

Git Bash は `/mnt/e/...` のような引数を Windows のパスに書き換える。

```
$ wsl -d Ubuntu-24.04 -- bash /mnt/e/Github/x/gen/build1.sh
bash: C:/Program Files/Git/mnt/e/Github/x/gen/build1.sh: No such file or directory
```

直し方：

```bash
MSYS_NO_PATHCONV=1 wsl -d Ubuntu-24.04 -- bash /mnt/e/Github/x/gen/build1.sh
```

Windows 側の Python から呼ぶときも環境変数で渡す（JWT の `cs/infra.py`）：

```python
def wsl(cmd, check=True):
    r = subprocess.run(['wsl', '-d', 'Ubuntu-24.04', '--', 'bash', '-lc', cmd],
                       capture_output=True, text=True, encoding='utf-8', errors='replace',
                       env=dict(os.environ, MSYS_NO_PATHCONV='1'))
    ...

def wsl_path(p):            # E:\Github\... -> /mnt/e/Github/...
    d, rest = p[0].lower(), p[2:].replace('\\', '/')
    return f'/mnt/{d}{rest}'
```

### 引用符の入れ子：複雑なコマンドはスクリプトのファイルにする

`wsl ... -- bash -lc '...'` の中で、さらに `"`、`'`、ヒアドキュメント、改行を入れると壊れる（`syntax error near unexpected token` が出た）。数行を超えるものは、リポジトリ（E: 上）にシェルスクリプトを書き、`MSYS_NO_PATHCONV=1 wsl -d Ubuntu-24.04 -- bash /mnt/e/.../run_all.sh` で流す。スクリプトにすると再現用の資産にもなる。

### 文字コード

- Windows 側の Python が日本語を出すと `cp932` で落ちる → `PYTHONIOENCODING=utf-8` を付けるか、`sys.stdout.reconfigure(encoding='utf-8')`。
- PowerShell の日本語のエラーメッセージは Git Bash では文字化けする（意味は HRESULT で読む）。
- Git の改行の警告が多いときは `git -c core.autocrlf=false commit ...`。

## 4. WSL の中の Python 環境

- `sudo` はパスワードが要る（`sudo -n true` が失敗する）。**apt で入れられない前提**で、利用者の領域だけで環境を作る。
- venv は WSL のホーム（`~/ragcase/.venv`）に作った。コードとデータは E: 上のリポジトリ（`/mnt/e/Github/...`）に置き、venv の Python で実行する。`/mnt/e` 越しの I/O は ext4 より遅いので、大量の小さなファイル（venv、モデルのキャッシュ）はホームに置く (要確認：速度は測っていない)。
- 最初に作った venv では pip のインストールがログも残さず失敗した（torch が入っていなかった）。`python3 -m venv --without-pip .venv` → `get-pip.py` で作り直して通った (要確認：原因は ensurepip の欠如か、バックグラウンド実行の打ち切りか)。`uv` は `~/.local/bin` にあった。
- PyTorch は CUDA 版の index から：`pip install torch --index-url https://download.pytorch.org/whl/cu124`。数 GB あるので、バックグラウンドで流してログを見る。
- Hugging Face の進捗表示はログを汚すので `HF_HUB_DISABLE_PROGRESS_BARS=1`。

## 5. コンテナごとの要点

### 共通

- ポートは `-p ホスト:コンテナ` で公開すれば、**Windows 側から `localhost:<ホスト>` で届く**（Git Bash の `curl localhost:9200`、Windows の Python の `requests`）。
- ほかのアプリと衝突しにくいポートを使う：OpenSearch 9200、検索サービス 8765、Keycloak 18080→8080、Postgres 15432→5432。
- 起動は「起動 → 準備できるまで待つ → 失敗ならログを出す」をスクリプトにする。待たずに次へ進むと、接続拒否を実験の失敗と取り違える。
- 終わったら止める。コンテナ名を決めておき、`docker rm -f <名前>` で消す。残りは `docker ps -a --format '{{.Names}}' | grep cs- || echo no-containers` で確かめる。

### OpenSearch（RAG・AgentOps）

日本語の解析器を入れたイメージを WSL の中で作った。

```dockerfile
FROM opensearchproject/opensearch:2.19.1
RUN /usr/share/opensearch/bin/opensearch-plugin install --batch analysis-kuromoji analysis-icu
```

```bash
docker rm -f osja >/dev/null 2>&1
docker run -d --name osja -p 9200:9200 \
  -e discovery.type=single-node -e DISABLE_SECURITY_PLUGIN=true -e DISABLE_INSTALL_DEMO_CONFIG=true \
  -e "OPENSEARCH_JAVA_OPTS=-Xms2g -Xmx2g" os-ja:2.19.1 >/dev/null
for i in $(seq 1 60); do curl -s localhost:9200 >/dev/null && break; sleep 3; done
curl -s "localhost:9200/_cat/plugins?h=component" | sort -u | grep -E 'kuromoji|icu|neural|knn'
```

- 実使用は約 2.7 GB。検索サービス（埋め込みと再ランキングのモデル）が約 1.7 GB。WSL 全体（vmmemWSL）で約 5.2 GB。
- Python のクライアント（opensearch-py）は新しい版でキーワード引数が必須（`indices.exists(index=idx)`）。
- 試験用の構成なのでセキュリティのプラグインは無効。公開リポジトリにはその旨を書く。

### 検索サービス（WSL の中で長く動かすプロセス）

- `kb_service.py serve` を WSL の中で動かし、Windows 側のエージェント（`claude -p` の MCP サーバ）から HTTP で呼んだ。
- `nohup ... &` を付けた起動スクリプトを `wsl ... -- bash start.sh` で呼ぶと、ツールの呼び出しが戻らずタイムアウトした。動いたのは、Claude Code の **バックグラウンド実行で `exec` を付けてフォアグラウンドのまま動かす**方法：
  ```bash
  MSYS_NO_PATHCONV=1 wsl -d Ubuntu-24.04 -- bash -lc "cd /mnt/e/Github/<repo>/kb && HF_HUB_DISABLE_PROGRESS_BARS=1 exec ~/ragcase/.venv/bin/python -W ignore kb_service.py serve"
  # （run_in_background で起動し、別の呼び出しで health を待つ）
  for i in $(seq 1 60); do curl -s localhost:8765/health | grep -q ok && break; sleep 5; done
  ```
  `wsl` の呼び出しが終わると、そこから `&` で起こしたプロセスがどう扱われるかは確かめていない (要確認)。
- GPU は 1 枚なので、モデルの呼び出しはロックで直列にした。同じ問いが何度も来るので、埋め込みを `lru_cache` でキャッシュした（1 回 3.6 秒かかっていた）。
- 「OpenSearch が上がっていなければ起動してからサービスを起動する」を 1 行にしておくと、再開が楽：`curl -s localhost:9200 >/dev/null && echo os-up || bash .../start_os.sh`。

### Keycloak 26.8 と Postgres 16（JWT）

`cs/infra.py` の `up()`／`down()` が、realm の JSON を書き出し、2 つのコンテナを起動し、準備を待つ。

```bash
docker run -d --name cs-kc -p 18080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
  -e JAVA_OPTS_KC_HEAP='-Xms256m -Xmx640m' \
  -v /mnt/e/Github/<repo>/kc/import:/opt/keycloak/data/import:ro \
  quay.io/keycloak/keycloak:26.8.0 start-dev --import-realm --features=token-exchange-standard:v2
docker run -d --name cs-pg -p 15432:5432 -e POSTGRES_USER=app -e POSTGRES_PASSWORD=app -e POSTGRES_DB=saas postgres:16-alpine
```

- 準備の判定は `http://localhost:18080/realms/<realm>/.well-known/openid-configuration` が 200 になるまで（最大 240 秒、3 秒おき）。実際の起動は約 35 秒。失敗したら `docker logs --tail 40 cs-kc` を例外に入れる。
- メモリは 2 つで約 0.8 GB（`docker stats --no-stream` で測って結果に記録）。イメージは Keycloak 762 MB。
- realm の JSON は Python で生成し、リポジトリの `kc/import/` に書いて、読み取り専用でマウントする（`/mnt/e/...` に変換したパス）。
- **つまずき**：
  - import の JSON に `clientScopes` を書くと、組み込みのスコープ（basic、roles など）が**置き換わって消える**。宛先用のスコープは import の後に管理 API で作る（`setup_scopes()`）。
  - クレーム名の `.` は入れ子の意味になる。名前空間の URI（`https://claims.example.com/`）の点はエスケープする（`https://claims\.example\.com/`）。
  - 宣言的なユーザープロファイルが常に有効で、定義していない利用者属性は既定で使えない。試験では `unmanagedAttributePolicy: ENABLED` にした。
  - AT のヘッダーを `at+jwt` にするのはクライアントの属性 `access.token.header.type.rfc9068`。軽量アクセストークン（`client.use.lightweight.access.token.enabled`）ではマッパーのクレームが落ちる。
  - 標準トークン交換はクライアント属性 `standard.token.exchange.enabled` と起動時の `--features=token-exchange-standard:v2`。
- パスワードやクライアントシークレットは試験用の固定値（`Passw0rd!`、`<client>-secret`）。コンテナの設定の試験用の値はリポジトリに入れてよいが、試験用の鍵（`keys/`）は gitignore。

## 6. メモリ：32 GB でも逼迫する

AgentOps v2 の実験中、Claude Code が**メモリ不足でバックグラウンドの作業をすべて自動停止**した（2 回。空きは 5.6 GB と 6.8 GB）。

| 原因 | 中身 |
| --- | --- |
| 同時実行の多さ | `claude -p` を十数個同時に動かし、それぞれに MCP サーバを付けていた |
| WSL の常駐 | OpenSearch 2.7 GB＋検索サービス 1.7 GB（vmmemWSL 5.2 GB） |
| 実験と無関係の常駐の積み重ね | 古い Claude Code のセッション（各 0.3〜0.6 GB）、Chrome 21 プロセス 3.0 GB、PowerShell 43 プロセス 2.2 GB、メモリ圧縮 1.9 GB。コミット済みメモリは 46 GB で物理を超えていた |

**どうしたか・次にどうするか**：

- 同時実行を 2〜4 に落とした（Haiku 4、Sonnet 3、のちに 2）。所要時間は延びるが止まらない。
- 実験は**完了済みの実行を飛ばして再開できる**作りにした（結果を 1 行ずつ JSONL に追記し、実行 ID で判定）。停止しても保存済みの記録は消えなかった。
- 停止後も、検索なしで動き続けた実験のプロセスがあった。無効な記録が増えないよう手で止め、保存済みの記録が検索断の影響を受けていないか検査した。Windows 側のプロセスは `taskkill //F //PID <pid>`（Git Bash では `//`）、コマンドラインで探すときは `Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -match '...' }`。WSL 側は `pkill -f kb_service.py`。
- 空きメモリは `powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1MB"` で、実験の前と途中に見る。内訳はプロセス名ごとの作業セットで集計して報告した。
- 自動停止は Claude Code を環境変数 `CLAUDE_CODE_DISABLE_BG_SHELL_PRESSURE_REAP=1` 付きで起動すると無効にできる（と案内した。効果は試していない (要確認)）。
- **止まった作業を、ユーザーの了承なしに再起動しない**。状態の表（完了・予定）と再開の案（同時実行数、回数、所要）を示して「再開」を待つ。
- 実験と無関係のプロセス（古いセッションなど）は、こちらからは判断できないので触らない。閉じると空くことを伝える。

## 7. ディスク：C: も E: も逼迫している

| 時点 | C: | E: |
| --- | --- | --- |
| RAG の回（11/14） | 476G 中 413G 使用（87%） | 932G 中 871G（94%、空き 61G） |
| JWT の回（11/17） | 88〜89%（空き 57〜61G） | 98〜99%（空き 19〜26G） |

- 着手前と、大きなもの（イメージ、モデル、node_modules）を入れる前に `df -h /c /e` と、WSL の中の `df -h /` を見る。
- 追加の見積もりを先に言う（JWT の回：「Keycloak のイメージは約 0.5〜0.8 GB、ディスクの追加は 3 GB 以内、同時に動かすコンテナは 2 つまで」）。
- 置き場所：成果物・リポジトリ・WSL の仮想ディスク・PDF は E:。C: には置かない（Claude Code の一時ファイルは C: の一時領域に出るので、大きな中間生成物は E: に出す）。
- E: の削除はユーザーが自分で進める（「E ドライブの削除については別途進めます」）。こちらからは消さない。
- WSL の仮想ディスク（ext4.vhdx）は、中でファイルを消しても自動では縮まない。縮めるには WSL を止めて最適化する（`wsl --shutdown` の後に `Optimize-VHD` や `diskpart` の compact） (要確認：この機では未実施。管理者権限が要る)。
- 使っていない Docker Desktop のデータ（C: の約 5.9 GB）は削除の候補だが、ユーザーの判断に任せる (要確認)。
- WSL の中の Docker の掃除は `docker images`／`docker system df` で量を見てから、使わないイメージを `docker rmi`。ビルドの残り（`<none>` のイメージ、終了したコンテナ）も溜まる（記録では 12 日前に Exited (137) のコンテナが残っていた）。

## 8. 片付けの手順（回の終わり）

1. 実験のコンテナを止めて消す（`down()`、`docker rm -f osja`）。残りが無いことを `docker ps -a` で確かめる。
2. WSL の中で動かしたサービスを止める（`pkill -f`）。
3. Windows 側に残った実験のプロセスが無いか見る。
4. `df -h /c /e` を見て、増えた分を報告する。
5. 再実行の手順（`start_os.sh`、`run_all.py`、前提「Windows から WSL（Ubuntu-24.04）の Docker が使えること」、必要メモリ）を README に書く。
