module.exports = (robot) ->
    dirs = [
        "**Atalhos de Compilação:** //vigoreli \n"
        "**Fontes Jboss:** //caetano \n"
        "**Wars Jboss:** //laranjeiras \n"
        "**Wars Docker:** //JV-FWK-DEV02/users/FWK \n"
        "**Plugins TFS:** //10.80.128.46 \n"
        "**Manuais DATASUL:** //caetano/progress_repository/DDK/11.5-X SNAPSHOT/src/manual \n"
        "**Ambientes LOGIX:** //arpoador/Atalhos_SQA \n"
        "**Deltas:** //ibiza/Deltas \n"
        "**Download GoGlobal:** ftp://ftp.graphon.com/pub/gg4/4.8.2.21477"
        ]
        
    title = "## _Diretórios TOTVS_"

    robot.hear /diretorios totvs/, (msg) ->
        msg.send "#{title} \n #{dirs}"