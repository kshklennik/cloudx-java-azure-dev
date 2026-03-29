ARG JAVA_VERSION=17
FROM mcr.microsoft.com/azure-functions/java:4-java${JAVA_VERSION}-build AS installer-env

ARG AZ_FUNC_APP_NAME
ARG AZ_FUNC_RG
ARG AZ_FUNC_REGION
ARG AZ_FUNC_OS
ARG AZ_FUNC_JAVA_VERSION
ARG AZ_SERVICE_PLAN_NAME
ARG AZ_PRICING_TIER

ENV AZ_FUNC_APP_NAME=${AZ_FUNC_APP_NAME} \
    AZ_FUNC_RG=${AZ_FUNC_RG} \
    AZ_FUNC_REGION=${AZ_FUNC_REGION} \
    AZ_FUNC_OS=${AZ_FUNC_OS} \
    AZ_FUNC_JAVA_VERSION=${AZ_FUNC_JAVA_VERSION} \
    AZ_SERVICE_PLAN_NAME=${AZ_SERVICE_PLAN_NAME} \
    AZ_PRICING_TIER=${AZ_PRICING_TIER}

COPY . /src/java-function-app

RUN cd /src/java-function-app && \
    mkdir -p /home/site/wwwroot && \
    mvn clean package && \
    cd ./target/azure-functions/ && \
    cd $(ls -d */ | head -n 1) && \
    cp -a . /home/site/wwwroot

FROM mcr.microsoft.com/azure-functions/java:4-java${JAVA_VERSION}-appservice

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY --from=installer-env ["/home/site/wwwroot", "/home/site/wwwroot"]

RUN echo "===== FINAL STRUCTURE =====" && find /home/site/wwwroot -maxdepth 5 -print