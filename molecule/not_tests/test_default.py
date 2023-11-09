# molecule/default/tests/test_default.py
def test_nginx_installed(host):
    nginx = host.package("nginx")
    assert nginx.is_installed
    apache = host.package("apache2")
    assert apache.is_installed