#!/usr/bin/python3
from pathlib import Path
import tempfile
from deployment import config, download, install, run, service, unit

HERE = Path(__file__).resolve().parent
app = config(HERE)['socketything']
with tempfile.TemporaryDirectory() as temporary:
    stage = Path(temporary)
    artifact = download(app['release_url'], app['release_url'] + '.sha256', stage, '/opt/apps/socketything/current/socketything')
    changed = install(artifact, '/opt/apps/socketything/current/socketything', 0o755)
    environment = stage / 'environment'
    environment.write_text(app['environment'].strip() + '\nSECRET_KEY_BASE=' + app['key_base'].strip() + '\n')
    environment.chmod(0o600)
    changed |= install(environment, '/etc/socketything.env', 0o600)
changed |= unit(HERE / 'files/socketything.service', 'socketything.service')
service('socketything.service', changed, ['/opt/apps/socketything/current/socketything', '/etc/socketything.env', '/etc/systemd/system/socketything.service'])
run('curl', '--fail', '--silent', '--show-error', '--retry', '30', '--retry-delay', '1', '--retry-connrefused', 'http://127.0.0.1:4000/')
