Tor
Using Tor as a proxy in Firefox.
tor, security, privacy, anonymity, tor browser, firefox, proxy

> Using the Tor Browser is more secure than methods below!

## Installing Tor daemon

This is required for all methods below!

1. Install the tor package (if you use Gentoo run `emerge net-vpn/tor`),
* Enable and start Tor daemon,
	* OpenRC: `rc-update add tor default && rc-service tor start`
	* systemd: `systemctl enable tor --now`

## Opening onion links in Firefox

We have to proxy requests to onion addresses to Tor.

### Steps

1. Download the file with proxy rules: `wget https://debooger.xyz/assets/security/torproxy`,
* Move the file somewhere (I recommend `~/.local/share` directory),
* Open Firefox proxy settings,</br>
![Proxy settings](/assets/pix/security/0_firefoxsettings.webp)
* Select the previously downloaded file,</br>
![Selecting file](/assets/pix/security/1_firefoxsettings.webp)
* Enable proxy when using SOCKS v5,</br>
![SOCKS v5 proxy](/assets/pix/security/2_firefoxsettings.webp)
* Restart Firefox.

## Routing everything through Tor

We can use a free software proxy switcher addon.
I recommend [Proxy SwitchyOmega](https://addons.mozilla.org/en-US/firefox/addon/switchyomega).

1. Install [Proxy SwitchyOmega](https://addons.mozilla.org/en-US/firefox/addon/switchyomega).
* Open SwitchyOmega settings,</br>
![SwitchyOmega settings](/assets/pix/security/0_switchyomega.webp)
* Create a new proxy profile,</br>
![Creating a profile](/assets/pix/security/1_switchyomega.webp)
* Select SOCKS5 protocol, set the server to 127.0.0.1, and port to 9050,</br>
![Profile settings](/assets/pix/security/2_switchyomega.webp)
* (Optional) Add servers to the bypass list,</br>
![Bypass list](/assets/pix/security/3_switchyomega.webp)
* Apply changes,</br>
![Applying changes](/assets/pix/security/4_switchyomega.webp)
* Now you can toggle Tor! (select [Direct] option to disable it)</br>
![Toggling Tor](/assets/pix/security/5_switchyomega.webp)
