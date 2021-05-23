EMAIL_HOST = "{{ mail.server }}"
DEFAULT_FROM_EMAIL = "{{ machine_name }}@{{ email_from }}"
EMAIL_PORT = "{{ mail.port }}"
EMAIL_HOST_PASSWORD = "{{ mail.password }}"
EMAIL_HOST_USER = "{{ mail.user }}"
EMAIL_USE_TLS = True

BASE_URL = "{{ traefik.url }}"
SITE_ROOT = "{{ site_root }}"
DEBUG = False
SITE_NAME = "{{ site_name }}"
ALLOWED_HOSTS = ["{{ traefik.url }}"]
CSRF_TRUSTED_ORIGINS = ["{{ traefik.url }}"]
PING_ENDPOINT = SITE_ROOT + "/ping/"

# SEE https://github.com/linuxserver/docker-healthchecks/issues/37
# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.mysql',
#         'HOST': "{{sql_host}}",
#         'PORT': "{{sql_port}}",
#         'NAME': "{{sql_db}}",
#         'USER': "{{sql_user}}",
#         'PASSWORD': "{{sql_password}}",
#         'TEST': {'CHARSET': 'UTF8'}
#     }
# }

PUSHBULLET_CLIENT_ID = None
PUSHBULLET_CLIENT_SECRET = "{{ pushbullet.key }}"

REGISTRATION_OPEN = False
