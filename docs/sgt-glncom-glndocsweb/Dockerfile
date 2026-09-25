FROM registry.global.ccc.srvb.can.paas.cloudcenter.corp/produban/nginx-1-28-ubi8:1.1.12.RELEASE

USER root


ENV APP_HOME=/usr/share/nginx/html \
    CONF_HOME=/etc/nginx
    

COPY dist/conf.d/* $CONF_HOME/conf.d/
COPY dist/html/ $APP_HOME/
RUN chown -R 999:0 $CONF_HOME && \
	chown -R 999:0 $APP_HOME && \
	chmod -R 775 $APP_HOME && \
	chmod -R 775 $CONF_HOME

USER 999
