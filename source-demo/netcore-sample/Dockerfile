#stage1 - build da aplicação
FROM registry.access.redhat.com/ubi8/dotnet-70:7.0-23 as builder

COPY . .

RUN dotnet publish -c Release

#stage2 - geração da imagem final
FROM registry.access.redhat.com/ubi8/dotnet-70-runtime:7.0-23

COPY --from=builder /opt/app-root/src/bin/Release/net7.0 .

EXPOSE 8080
CMD ["dotnet", "TodoApi.dll"]