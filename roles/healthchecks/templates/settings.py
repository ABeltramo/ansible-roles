EMAIL_HOST = "{{ mail.server }}"
DEFAULT_FROM_EMAIL = "{{ machine_name }}@{{ mail.default_from }}"
EMAIL_PORT = "{{ mail.port }}"
EMAIL_HOST_PASSWORD = "{{ mail.password }}"
EMAIL_HOST_USER = "{{ mail.user }}"
EMAIL_USE_TLS = True

BASE_URL = "{{ traefik.url }}"
SITE_ROOT = "http://{{ traefik.url }}"
DEBUG = False
SITE_NAME = "{{ site_name | default('Healthchecks') }}"
ALLOWED_HOSTS = ["{{ traefik.url }}"]
CSRF_TRUSTED_ORIGINS = [
    "http://{{ traefik.url }}"]  # As of Django 4.0, the values in the CSRF_TRUSTED_ORIGINS setting must start with a scheme (usually http:// or https://) but found checks.lan
PING_ENDPOINT = SITE_ROOT + "/ping/"

# SEE https://github.com/linuxserver/docker-healthchecks/issues/37
# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.mysql',
#         'HOST': "{{SQL.host}}",
#         'PORT': "{{SQL.port | default('3306')}}",
#         'NAME': "{{SQL.db}}",
#         'USER': "{{SQL.user}}",
#         'PASSWORD': "{{SQL.password}}",
#         'TEST': {'CHARSET': 'UTF8'}
#     }
# }

PUSHBULLET_CLIENT_ID = None
PUSHBULLET_CLIENT_SECRET = "{{ pushbullet.key }}"

REGISTRATION_OPEN = False
