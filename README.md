# Monero RPC Control Panel for Windows

!["Main"](https://img.shields.io/github/license/techcnet/MoneroRPC-ControlPanel)
![License](https://img.shields.io/github/license/techcnet/MoneroRPC-ControlPanel)
![GitHub last commit](https://img.shields.io/github/last-commit/techcnet/MoneroRPC-ControlPanel)
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://tech-c.net/donation/)

A control panel for Windows to control and configure the monero wallet RPC. The download includes the Delphi source code. After download the monero-wallet-rpc.exe has to be extracted from monero-wallet-rpc-x64.zip or monero-wallet-rpc-x86.zip, depending on your Windows version. Otherwise, download monero-wallet-rpc.exe from https://github.com/monero-project/monero/releases

!["Main"](https://tech-c.net/site/assets/files/1239/mainform.jpg)

## Configuration
Before you start you have to specify the path to your **Wallet** file in the configuration. Other **RPC** options are described in the ["RPC documentation"](https://docs.getmonero.org/interacting/monero-wallet-rpc-reference/#rpc). The **Remote node** can also be changed to, for example, one of the ["listed here"](https://xmr.ditatompel.com/remote-nodes).

!["Configuration"](https://tech-c.net/site/assets/files/1239/config.jpg)

## Curl
Windows 10 and 11 also comes with curl which makes it easier to execute ["JSON-RPC Methods"](https://docs.getmonero.org/rpc-library/wallet-rpc/#index-of-json-rpc-methods). The curl request have to start with {"jsonrpc":"2.0",... The store button shows an example. The send button will execute the command.

!["Curl"](https://tech-c.net/site/assets/files/1239/curl.jpg)

## Remarks
Moneros RPC wallet has some limitations. As long as the wallet gets synchronized the RPC is inresponsive. This can be some minutes up to hours. The RPC has also no auto-save feature. A Store-command has to be executed before every RPC ternination. Otherwise, the RPC will synchronize by every start again from the same height. Therefore, it's recommented to use the store command in the curl windows as described above.
