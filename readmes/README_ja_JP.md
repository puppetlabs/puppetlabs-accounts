# アカウント

#### 目次
1. [説明](#description)
2. [セットアップ - アカウントを開始するにあたっての基本設定](#setup)
3. [使用方法 - 設定オプションと追加機能](#usage)
    * [ユーザアカウントの宣言](#declare-user-accounts)
    * [ホームディレクトリのカスタマイズ](#customize-the-home-directory)
    * [アカウントのロック](#lock-accounts)
    * [SSHキーの管理](#manage-ssh-keys)
4. [参考 - モジュールの機能と動作について](#reference)
5. [制約事項 - OSの互換性など](#limitations)
6. [開発 - モジュール貢献についてのガイド](#development)


## 説明

アカウントモジュールは、ログインアカウントとサービスアカウントに関連するリソースを管理します。

このモジュールは、多くのUNIX/Linuxオペレーティングシステムで動作します。Microsoft Windowsプラットフォームでのアカウントの設定はサポートされていません。

## セットアップ

### アカウントの使用開始

Puppetで管理されているノードのマニフェストで`accounts`クラスを宣言します。

~~~puppet
node default {
  accounts::user { 'dan': }
  accounts::user { 'morgan': }
}
~~~

上記の例では、DanとMorganのアカウント、ホームディレクトリ、グループを作成しています。

## 使用方法

### ユーザアカウントの宣言

~~~puppet
accounts::user { 'bob':
  uid      => '4001',
  gid      => '4001',
  group    => 'staff',
  shell    => '/bin/bash',
  password => '!!',
  locked   => false,
}
~~~

### ホームディレクトリのカスタマイズ

単純なbashrcおよびbash\ _profile rcファイルは、各アカウントのPuppetによって管理されます。これらのrcファイルは単純なエイリアスの追加、プロンプトの更新、パスへの~/binの追加を行い、(このモジュールでは管理されていない)次のファイルを以下の順序でソースします。

 1. `/etc/bashrc`
 2. `/etc/bashrc.puppet`
 3. `~/.bashrc.custom`

アカウント所有者は、bashrc.customファイルを管理することでシェルをカスタマイズできます。さらに、システム管理者は、 '/etc/bashrc.puppet'ファイルを管理することで、bashシェルを持つすべてのアカウントに影響を与えるプロファイルの変更を行うことができます。

電子メールフォワードをインストールするには、 `forward_content`または` forward_source`パラメータを使って `.forward`ファイルを設定します。

### アカウントのロック

アカウントの`locked`パラメータをtrueに設定して、アカウントをロックします。

例:　

~~~puppet
accounts::user { 'villain':
  comment => 'Bad Person',
  locked  => true
}
~~~

アカウントモジュールは、Puppetが管理しているシステムに適した無効なシェルにアカウントを設定し、ユーザがそのアカウントにアクセスしようとすると次のメッセージを表示します。

~~~
$ ssh villain@centos56
This account is currently not available.
Connection to 172.16.214.129 closed.
~~~

### SSHキーの管理

`accounts::user`定義型の`sshkeys`属性でSSHキーを管理します。このパラメータは、パブリックキーコンテンツの配列を文字列として受け取ります。

例:

~~~puppet
accounts::user { 'jeff':
  comment => 'Jeff McCune',
  groups  => [
    'admin',
    'sudonopw',
  ],
  uid     => '1112',
  gid     => '1112',
  sshkeys => [
    'ssh-rsa AAAAB3Nza...== jeff@puppetlabs.com',
    'ssh-dss AAAAB3Nza...== jeff@metamachine.net',
  ],
}
~~~

このモジュールは、カスタムロケーションでのSSHキーの配置をサポートしています。`accounts::user` 定義型の`sshkey_custom_path`属性の値を指定すると、モジュールは指定されたファイルにキーを配置します。このモジュールはフルパスではなく、指定されたファイルのみを管理します。`purge_sshkeys`をtrueに設定してカスタムパスを設定した場合、カスタムパスのSSHキーのみがパージされます。

例:

~~~puppet
accounts::user { 'gerrard':
  sshkey_custom_path => '/var/lib/ssh/gerrard/authorized_keys',
  shell              => '/bin/zsh',
  comment            => 'Gerrard Geldenhuis',
  groups             => [
    'engineering',
    'automation',
  ],
  uid                => '1117',
  gid                => '1117',
  sshkeys            => [
    'ssh-rsa AAAAB9Aza...== gerrard@dirtyfruit.co.uk',
    'ssh-dss AAAAB9Aza...== gerrard@dojo.training',
  ],
  password           => '!!',
}
~~~

`sshkey_custom_path`の設定は、通常、sshd設定ファイルの`AuthorizedKeysFile /var/lib/ssh/%u/authorized_keys`の設定に関連します。

## リファレンス

[REFERENCE.md](https://github.com/puppetlabs/puppetlabs-accounts/blob/main/REFERENCE.md)を参照してください。

## 制約事項

 サポートされているオペレーティングシステムの一覧については、[metadata.json](https://github.com/puppetlabs/puppetlabs-accounts/blob/main/metadata.json)を参照してください。

### pe\_accountsからの変更

アカウントモジュールは、PEバージョン2015.2以前に同梱されているpe\_accountsモジュールの置き換えとして設計されています。変更の一部には、基本クラスの削除、検証の改善、ユーザのホームディレクトリで管理すべきファイルと管理すべきではないファイルに関する柔軟性の強化が含まれます。

例えば、.bashrcと.bash\_profileの各ファイルはデフォルトでは管理されませんが、`bashrc_content`パラメータと`bash_profile_content`パラメータを使ってカスタムコンテンツを渡すことができます。pe\_accountsで管理されているこれらの2つのファイルのコンテンツは、`bashrc_content => file('accounts/shell/bashrc')`と`bash_profile_content => file('accounts/shell/bash_profile')`を`accounts::user`定義型に渡すことで引き続き使用できます.


## 開発

本モジュールで問題が発生した場合、またはリクエストしたい機能がある場合、[チケットを送信](https://tickets.puppetlabs.com/browse/MODULES/)してください。

本モジュールの導入時に問題がある場合は、[サポートにお問い合わせ](http://puppetlabs.com/services/customer-support)ください。
