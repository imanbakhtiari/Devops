FROM quay.io/keycloak/keycloak:23.0.7 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
#ENV KC_HTTP_ENABLED=true
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
#RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:sso.basa.ir,IP:127.0.0.1" -keystore conf/server.keystore

#ADD --chown=keycloak:keycloak ./dasniko.keycloak-2fa-sms-authenticator.jar /opt/keycloak/providers/dasniko.keycloak-2fa-sms-authenticator.jar
#ADD --chown=keycloak:keycloak ./themes/custom /opt/keycloak/themes/custom
#COPY custom-config/standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/standalone-ha.xml
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:23.0.7
COPY --from=builder /opt/keycloak/ /opt/keycloak/
ENV JBOSS_NODE_NAME=node1
#RUN /opt/keycloak/bin/kc.sh build
# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://10.130.1.25:5000/kc
ENV KC_DB_USERNAME=postgres
ENV KC_DB_PASSWORD=password
#ENV KC_HOSTNAME=sso.basa.ir
ENV KC_HTTP_ENABLED=true
ENV KC_HOSTNAME_URL=https://sso.domain.tld
#CMD ["/opt/keycloak/bin/kc.sh", "start"]
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
#RUN /opt/keycloak/bin/kc.sh start
