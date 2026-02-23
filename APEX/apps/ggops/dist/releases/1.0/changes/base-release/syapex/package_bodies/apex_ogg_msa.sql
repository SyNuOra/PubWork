-- liquibase formatted sql
-- changeset SYAPEX:1771865126469 stripComments:false  logicalFilePath:base-release/syapex/package_bodies/apex_ogg_msa.sql
-- sqlcl_snapshot src/database/syapex/package_bodies/apex_ogg_msa.sql:null:04a5b42d122a85711abb2758b404e7c0b5708481:create

create or replace package body syapex.apex_ogg_msa -- =============================================
-- Author:      Sydney Nurse@Oracle Switzerland
-- Create date: Covid-19 Pandemic October 2021
-- Description: Build to support the migration of Deployments between GoldenGate MSA Deployments
-- Global Parameters:
--      @      - None
--      
-- =============================================
 as
-- =============================================
-- Procedure:      CREATE_CREDENTIAL
-- Description: Creates an APEX Web Credential for the GoldenGate MSA Connection
-- Parameters:
--      @l_n_flow_id             - ID of the current Flow
--      @l_vc_credential          - Name of the connection Credentials
--      @l_vc_user                - Username for the connection
--      @l_vc_password            - Password for the connection
-- Returns:                         
-- =============================================
    procedure create_credential (
        l_n_flow_id     in number,
        l_vc_credential in varchar2,
        l_vc_user       in varchar2,
        l_vc_password   in varchar2
    ) as
    begin
        -- CREATE APEX Web Credential
        wwv_flow_api.create_credential(
            p_id                  => trunc(dbms_random.value(0, 100000)),
            p_name                => l_vc_credential,
            p_static_id           => replace(l_vc_credential, ' ', '_'),
            p_authentication_type => 'BASIC',
            p_namespace           => '',
            p_prompt_on_install   => true
        );

        apex_ogg_msa.update_credential(
            l_vc_credential => l_vc_credential,
            l_vc_user       => l_vc_user,
            l_vc_password   => l_vc_password
        );

    end create_credential;
-- =============================================
-- Procedure:      UPDATE_CREDENTIAL
-- Description: Updates the credential details an APEX Web Credential used by a GoldenGate MSA Connection
-- Parameters:
--      @l_vc_credential          - Name of the connection Credentials
--      @l_vc_user                - Name of the connection Credentials
--      @l_vc_password            - Name of the connection Credentials
-- Returns:                         
-- =============================================
    procedure update_credential (
        l_vc_credential in varchar2,
        l_vc_user       in varchar2,
        l_vc_password   in varchar2
    ) as
    begin
        -- UPDATE APEX Web Credential
        apex_credential.set_persistent_credentials(
            p_credential_static_id => replace(l_vc_credential, ' ', '_'),
            p_username             => l_vc_user,
            p_password             => l_vc_password
        );
    end update_credential;
-- =============================================
-- Procedure:      DELETE_CREDENTIAL
-- Description: Deletes the credential details an APEX Web Credential used by a GoldenGate MSA Connection
-- Parameters:
--      @l_n_flow_id             - ID of the current Flow
--      @l_vc_credential          - Name of the connection Credentials
-- Returns:                         
-- =============================================
    procedure delete_credential (
        l_n_flow_id     in number,
        l_vc_credential in varchar2
    ) as
    begin
        -- DELETE APEX Web Credential
       /**
        wwv_flow_api.drop_credential
        (
            p_id=> l_n_flow_id,
            p_name=> l_vc_credential,
            p_static_id=> replace(l_vc_credential,' ','_')
        );
        **/
        dbms_output.put_line('');
    end delete_credential;
-- =============================================
-- Procedure:      REST_UTL
-- Description: Utility to support Rest Calls
-- Parameters:
--      @l_vc_credential         - Name of the connection Credentials to use in the REST request
--      @l_vc_url                - The URL for the REST request 
--      @l_vc_method             - The HTTP method for the REST request
-- Returns: @l_response          - The Rest Response                        
-- =============================================
    procedure rest_utl (
        l_vc_credential in varchar2,
        l_vc_url        in varchar2,
        l_vc_method     in varchar2,
        l_vc_request    in varchar2,
        l_response      out clob
    ) as
    begin
        -- set any required headers for the request (suggested minimum required)
        apex_web_service.g_request_headers.delete();
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';   
        -- response received needs to be parsed
        if ( l_vc_request is null ) then
            l_response := apex_web_service.make_rest_request(
                p_url                  => l_vc_url,
                p_http_method          => l_vc_method,
                p_credential_static_id => l_vc_credential
            );
        else
            l_response := apex_web_service.make_rest_request(
                p_url                  => l_vc_url,
                p_http_method          => l_vc_method,
                p_credential_static_id => l_vc_credential,
                p_body                 => to_clob(l_vc_request)
            );
        end if;
        -- response received needs to be parsed
        dbms_output.put_line(l_response || chr(10));
        dbms_output.put_line('*******' || chr(10));
    end rest_utl;
-- =============================================
-- Procedure:      DEPLOYMENTS
-- Description: Working with GoldenGate MSA Deployments
-- Parameters:
--      @l_vc_host               - Name of the GoldenGate deployment host
--      @l_vc_deployment         - Name of the GoldenGate deployment
--      @l_vc_method             - The activity to perform [LIST, GET] 
-- Returns:                        
-- =============================================
    procedure deployments (
        l_vc_host       in varchar2,
        l_vc_deployment in varchar2,
        l_vc_method     in varchar2
    ) as

        l_vc_host_id              number;
        l_vc_host_addr            varchar2(1000);
        l_vc_host_creds           varchar2(256);
        l_vc_host_url             varchar2(4000);
        l_vc_build_title          varchar2(400);
        l_vc_build_dbms           varchar2(400);
        l_vc_build_label          varchar2(400);
        l_vc_build_platform       varchar2(400);
        l_vc_build_version        varchar2(400);
        l_vc_deployment_names     nvarchar2(400);
        l_vc_deployment_status    nvarchar2(400);
        l_vc_deployment_enabled   nvarchar2(400);
        l_vc_deployment_ogg_home  nvarchar2(400);
        l_vc_deployment_etc_home  nvarchar2(400);
        l_vc_deployment_conf_home nvarchar2(400);
        l_response                clob;
        l_build_response          clob;
    begin
        -- Get Deployments for provided host
        -- Get the Host address and associated credentials
        select
            host_id,
            host_address,
            replace(host_credential, ' ', '_')
        into
            l_vc_host_id,
            l_vc_host_addr,
            l_vc_host_creds
        from
            ggops_hosts
        where
            host_name = l_vc_host;
        
        -- Setup URL for LIST Deployments or GET a Deployment
        case
            when l_vc_deployment = 'metadata-catalog' then
                l_vc_host_url := 'https://'
                                 || l_vc_host_addr
                                 || s_servmgr
                                 || '/'
                                 || l_vc_deployment;
            when l_vc_method = 'LIST' then
                l_vc_host_url := 'https://'
                                 || l_vc_host_addr
                                 || s_servmgr
                                 || '/deployments';
            else
                l_vc_host_url := 'https://'
                                 || l_vc_host_addr
                                 || s_servmgr
                                 || '/deployments'
                                 || '/'
                                 || l_vc_deployment;
        end case;

        dbms_output.put_line('host_creds: '
                             || l_vc_host_creds || chr(10));
        dbms_output.put_line('host_uri: '
                             || l_vc_host_url || chr(10));
        dbms_output.put_line('*******' || chr(10));
        apex_ogg_msa.rest_utl(
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => l_vc_host_url,
            l_vc_method     => 'GET',
            l_response      => l_response
        );
    
        -- Does not handle multiple deployments per MSA installation
        -- Need. implement a cursor in future
        case l_vc_method
            when 'LIST' then
                merge into ggops_deployments dp
                using (
                    select
                        l_vc_host_id host_id,
                        name         deployment_name
                    from
                        (
                            select
                                name
                            from
                                    json_table ( l_response, '$.response.items[*]' null on empty
                                        columns (
                                            name varchar2 ( 400 ) path '$.name'
                                        )
                                    )
                                jt
                            where
                                name != 'ServiceManager'
                        )
                ) rest_src on ( dp.host_id = rest_src.host_id
                                and dp.deployment_name = rest_src.deployment_name )
                when not matched then
                insert (
                    dp.host_id,
                    dp.deployment_name )
                values
                    ( rest_src.host_id,
                      rest_src.deployment_name );

                commit;
                dbms_output.put_line('Commited Deployments: ' || chr(10));
                dbms_output.put_line('*******' || chr(10));
                for deps in (
                    select
                        deployment_name
                    from
                        ggops_deployments
                    where
                        host_id = l_vc_host_id
                ) loop
                    apex_ogg_msa.deployments(
                        l_vc_host       => l_vc_host,
                        l_vc_deployment => deps.deployment_name,
                        l_vc_method     => 'GET'
                    );
                end loop;

            when 'GET' then
                if l_vc_deployment = 'metadata-catalog' then
                    dbms_output.put_line('*******' || chr(10));
                else
                    dbms_output.put_line('Loading Deployments: '
                                         || l_vc_deployment || chr(10));
                    dbms_output.put_line('*******' || chr(10));
 
                    -- GET Build Info
                    apex_ogg_msa.rest_utl(
                        l_vc_credential => l_vc_host_creds,
                        l_vc_url        => 'https://'
                                    || l_vc_host_addr
                                    || '/services/'
                                    || l_vc_deployment
                                    || '/adminsrvr/v2/config/summary',
                        l_vc_method     => 'GET',
                        l_response      => l_build_response
                    );

                    select
                        title,
                        dbms,
                        label,
                        platform,
                        version
                    into
                        l_vc_build_title,
                        l_vc_build_dbms,
                        l_vc_build_label,
                        l_vc_build_platform,
                        l_vc_build_version
                    from
                            json_table ( l_build_response, '$.response[*]' null on empty
                                columns (
                                    title varchar2 ( 400 ) path '$.title',
                                    dbms varchar2 ( 400 ) path '$.build.dbms',
                                    label varchar2 ( 400 ) path '$.build.label',
                                    platform varchar2 ( 400 ) path '$.build.platform',
                                    version varchar2 ( 400 ) path '$.build.version'
                                )
                            )
                        jt;

                    dbms_output.put_line('Build Info - Title: '
                                         || l_vc_build_title
                                         || ', DB: '
                                         || l_vc_build_dbms
                                         || ', Label: '
                                         || l_vc_build_label
                                         || ', Platform: '
                                         || l_vc_build_platform
                                         || ', Version: '
                                         || l_vc_build_version || chr(10));

                    dbms_output.put_line('*******' || chr(10));
                    merge into ggops_deployments dp
                    using (
                        select
                            status,
                            enabled,
                            deployment_ogghome,
                            deployment_etchome,
                            deployment_confhome
                        from
                            json_table ( l_response, '$.response[*]' null on empty
                                columns (
                                    status varchar2 ( 400 ) path '$.status',
                                    enabled varchar2 ( 400 ) path '$.enabled',
                                    deployment_ogghome varchar2 ( 400 ) path '$.oggHome',
                                    deployment_etchome varchar2 ( 400 ) path '$.oggEtcHome',
                                    deployment_confhome varchar2 ( 400 ) path '$.oggConfHome'
                                )
                            )
                    ) rest_src on ( dp.host_id = l_vc_host_id
                                    and dp.deployment_name = l_vc_deployment )
                    when matched then update
                    set dp.deployment_ogghome = rest_src.deployment_ogghome,
                        dp.deployment_etchome = rest_src.deployment_etchome,
                        dp.deployment_confhome = rest_src.deployment_confhome,
                        dp.deployment_title = l_vc_build_title,
                        dp.deployment_label = l_vc_build_label,
                        dp.deployment_platform = l_vc_build_platform;

                    commit;
                end if;
        end case;

    end deployments;
-- =============================================
-- Procedure:      REPLICATION
-- Description: Working with GoldenGate MSA Deployment Services [ADMIN,DIST,RCVR]
-- Parameters:
--      @l_vc_host               - Name of the GoldenGate deployment host
--      @l_vc_deployment         - Name of the GoldenGate deployment
--      @l_vc_method             - The activity to perform [LIST, GET, POST (CREATE), PUT (REPLACE), DELETE] 
--      @l_vc_service            - The GoldenGare MSA service [adminsrvr,distsrvr,recvsrvr]
--      @l_vc_process_type       - The GoldenGare MSA process name admin:[extracts,replicats], distsrvr: [sources], recvsrvr: [targets]
--      @l_vc_process            - The GoldenGare MSA process name i.e. extract, replicat or path name
-- Returns:                        
-- =============================================
    procedure replication (
        l_vc_host         in varchar2,
        l_vc_deployment   in varchar2,
        l_vc_method       in varchar2,
        l_vc_service      in varchar2,
        l_vc_process_type in varchar2,
        l_vc_process      in varchar2
    ) as

        l_vc_host_addr             varchar2(1000);
        l_vc_host_creds            varchar2(256);
        l_vc_host_url              varchar2(4000);
        l_vc_deployment_id         number;
        l_vc_deployment_type       varchar2(100);
        l_vc_service_url           varchar2(4000) := '/services/'
                                           || l_vc_deployment
                                           || '/'
                                           || l_vc_service
                                           || '/v2/'
                                           || l_vc_process_type;
        l_vc_processes             varchar2(400);
        l_vc_config                varchar2(4000);
        l_response                 clob;
        l_vc_process_trail         varchar2(4000);
        l_vc_process_begin         varchar2(4000);
        l_vc_process_intent        varchar2(4000);
        l_vc_credential_id         number;
        l_vc_extract_type          varchar2(400);
        l_vc_non_oracle_domain     varchar2(4000);
        l_vc_non_oracle_credential varchar2(4000);
        /**
        l_vc_cred_domain_id number;
        l_vc_credential_id number;
        l_vc_extracts varchar2(400);
        l_vc_credential varchar2(4000); 
        l_vc_user varchar2(4000);
        l_vc_password varchar2(4000);
        **/
    begin
        
        -- setup URL based on service
        -- Get the Host address and associated credentials
        select
            hs.host_address,
            replace(hs.host_credential, ' ', '_') creds,
            dp.deployment_id,
            replace(
                regexp_substr(dp.deployment_title, '[^ ]+$'),
                'Manager',
                'Big Data'
            )                                     dep_type
        into
            l_vc_host_addr,
            l_vc_host_creds,
            l_vc_deployment_id,
            l_vc_deployment_type
        from
            ggops_hosts       hs,
            ggops_deployments dp
        where
                hs.host_name = l_vc_host
            and dp.deployment_name = l_vc_deployment
            and hs.host_id = dp.host_id;

        l_vc_host_url := 'https://'
                         || l_vc_host_addr
                         || l_vc_service_url;
        -- Update URL for a specific process
        if l_vc_process is not null then
            l_vc_host_url := l_vc_host_url
                             || '/'
                             || l_vc_process;
        end if;

        dbms_output.put_line('host_creds: '
                             || l_vc_host_creds || chr(10));
        dbms_output.put_line('host_uri: '
                             || l_vc_host_url || chr(10));
        dbms_output.put_line('*******' || chr(10));
        apex_ogg_msa.rest_utl(
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => l_vc_host_url,
            l_vc_method     => l_vc_method,
            l_response      => l_response
        );
        
        -- response.items[*]
        -- Need to manage multiple processes being returned
        if l_vc_process is null then -- WHEN TRUE THEN LIST
            for processes in (
                select
                    name,
                    substr(recvr_path_name,
                           instr(recvr_path_name, 'targets/') + 8) path_name
                from
                        json_table ( l_response, '$.response.items[*]' null on empty
                            columns (
                                name varchar2 ( 400 ) path '$.name',
                                recvr_path_name varchar2 ( 400 ) path '$.links[1].href'
                            )
                        )
                    jt
            ) loop
                dbms_output.put_line('Path name: '
                                     || processes.path_name || chr(10));
                dbms_output.put_line('*******' || chr(10));
                if ( l_vc_service = 'recvsrvr' ) then
                    l_vc_host_url := 'https://'
                                     || l_vc_host_addr
                                     || l_vc_service_url
                                     || '/'
                                     || processes.path_name;
                else
                    l_vc_host_url := 'https://'
                                     || l_vc_host_addr
                                     || l_vc_service_url
                                     || '/'
                                     || processes.name;
                end if;
                
                --'https://' || l_vc_host_addr || '/services/' || l_vc_deployment || '/adminsrvr/v2/' || l_vc_process_type || '/' || processes.name;

                dbms_output.put_line('Service url: '
                                     || l_vc_host_url || chr(10));
                dbms_output.put_line('*******' || chr(10));
                apex_ogg_msa.rest_utl(
                    l_vc_credential => l_vc_host_creds,
                    l_vc_url        => l_vc_host_url,
                    l_vc_method     => l_vc_method,
                    l_response      => l_response
                );

                select
                    extract_type
                into l_vc_extract_type
                from
                    json_table ( l_response, '$.response[*]' null on empty
                        columns (
                            extract_type varchar2 ( 400 ) path '$.type'
                        )
                    );
 
                -- Big Data Deployments do not have a credential, so need to skip the CRED DOMAIN and CREDS check
                if (
                    ( ( l_vc_extract_type != 'Source Extract' )
                    or ( l_vc_extract_type is null ) )
                    and l_vc_process_type in ( 'extracts', 'replicats' )
                ) then
                    dbms_output.put_line('IF: Process Type is '
                                         || l_vc_process_type
                                         || ' for Proces Name: '
                                         || processes.name || chr(10));

                    if ( ( l_vc_extract_type != 'Source Extract' )
                    or ( l_vc_extract_type is null ) ) then
                        dbms_output.put_line('Extracts' || chr(10));
                        if (
                            l_vc_deployment_type != 'Oracle'
                            and l_vc_process_type = 'replicats'
                        ) then
                            select
                                regexp_substr(config, '(USERIDALIAS[[:space:]])([[:alpha:]]+[^,])', 1, 1, null,
                                              2),
                                regexp_substr(config, '(DOMAIN[[:space:]])([[:alpha:]]+)', 1, 1, null,
                                              2)
                            into
                                l_vc_non_oracle_credential,
                                l_vc_non_oracle_domain
                            from
                                    json_table ( l_response, '$.response[*]' null on empty
                                        columns (
                                            config varchar2 ( 4000 ) format json without wrapper path '$.config'
                                        )
                                    )
                                jt;

                            dbms_output.put_line('domain:useralias = '
                                                 || l_vc_non_oracle_domain
                                                 || ':'
                                                 || l_vc_non_oracle_credential || chr(10));

                        end if;

                        merge into ggops_credential_domains cd
                        using (
                            select
                                nvl(domain, l_vc_non_oracle_domain) domain_name
                            from
                                json_table ( l_response, '$.response[*]' null on empty
                                    columns (
                                        domain varchar2 ( 400 ) path '$.credentials.domain'
                                    )
                                )
                        ) rest_src on ( cd.deployment_id = l_vc_deployment_id
                                        and cd.domain_name = rest_src.domain_name )
                        when not matched then
                        insert (
                            deployment_id,
                            domain_name )
                        values
                            ( l_vc_deployment_id,
                              rest_src.domain_name );

                        dbms_output.put_line('Credentials' || chr(10));
                        merge into ggops_credentials cr
                        using (
                            select
                                domain_id,
                                user_alias,
                                'DEFAULT'        connectuser,
                                'notAVal1dPa55!' connectpassword
                            from
                                (
                                    select
                                        cd.domain_id                              domain_id,
                                        nvl(jt.domain_, l_vc_non_oracle_domain)   domain_alias,
                                        nvl(jt.user_, l_vc_non_oracle_credential) user_alias
                                    from
                                            json_table ( l_response, '$.response[*]' null on empty
                                                columns (
                                                    domain_ varchar2 ( 400 ) path '$.credentials.domain',
                                                    user_ varchar2 ( 400 ) path '$.credentials.alias'
                                                )
                                            )
                                        jt,
                                            ggops_credential_domains cd
                                    where
                                            cd.domain_name = nvl(jt.domain_, l_vc_non_oracle_domain)
                                        and cd.deployment_id = l_vc_deployment_id
                                )
                        ) rest_src on ( cr.credential_domain_id = rest_src.domain_id
                                        and cr.user_alias = rest_src.user_alias )
                        when not matched then
                        insert (
                            credential_domain_id,
                            user_alias,
                            connectuser,
                            onnectpassword )
                        values
                            ( rest_src.domain_id,
                              rest_src.user_alias,
                              rest_src.connectuser,
                              rest_src.connectpassword );

                        merge into ggops_processes pr
                        using (
                            select
                                deployment_id,
                                process_name,
                                process_type,
                                process_trail,
                                process_begin,
                                process_intent,
                                credential_id
                            from
                                (
                                    select
                                        cd.deployment_id                                   deployment_id,
                                        processes.name                                     process_name,
                                        upper(substr(l_vc_process_type,
                                                     0,
                                                     length(l_vc_process_type) - 1))                    process_type,
                                        jt.process_target_trail || jt.process_source_trail process_trail,
                                        jt.domain_name,
                                        jt.user_alias,
                                        jt.process_begin,
                                        jt.process_intent,
                                        cr.user_id                                         credential_id
                                    from
                                            json_table ( l_response, '$.response[*]' null on empty
                                                columns (
                                                    process_target_trail varchar2 ( 400 ) path '$.targets.name',
                                                    process_source_trail varchar2 ( 400 ) path '$.source.name',
                                                    domain_name varchar2 ( 400 ) path '$.credentials.domain',
                                                    user_alias varchar2 ( 400 ) path '$.credentials.alias',
                                                    process_begin varchar2 ( 400 ) path '$.begin',
                                                    process_intent varchar2 ( 400 ) path '$.intent'
                                                )
                                            )
                                        jt,
                                            ggops_credential_domains cd,
                                            ggops_credentials        cr
                                    where
                                            cd.domain_name = nvl(jt.domain_name, l_vc_non_oracle_domain)
                                        and cd.deployment_id = l_vc_deployment_id
                                        and cr.credential_domain_id = cd.domain_id
                                        and cr.user_alias = nvl(jt.user_alias, l_vc_non_oracle_credential)
                                )
                        ) rest_src on ( pr.deployment_id = rest_src.deployment_id
                                        and pr.process_name = rest_src.process_name )
                        when matched then update
                        set pr.process_type = rest_src.process_type,
                            pr.process_trail = rest_src.process_trail,
                            pr.process_begin = rest_src.process_begin,
                            pr.process_intent = rest_src.process_intent,
                            pr.credential_id = rest_src.credential_id
                        when not matched then
                        insert (
                            deployment_id,
                            process_name,
                            process_type,
                            process_trail,
                            process_begin,
                            process_intent,
                            credential_id )
                        values
                            ( rest_src.deployment_id,
                              rest_src.process_name,
                              rest_src.process_type,
                              rest_src.process_trail,
                              rest_src.process_begin,
                              rest_src.process_intent,
                              rest_src.credential_id );

                    end if;
                -- Else Try to get Everything else that does not ha credentials
                elsif ( l_vc_extract_type = 'Source Extract' ) then
                    dbms_output.put_line('ELSIF: Process Type is '
                                         || l_vc_process_type
                                         || ' for Proces Name: '
                                         || processes.name || chr(10));

                    merge into ggops_processes pr
                    using (
                        select
                            deployment_id,
                            process_name,
                            process_type,
                            process_trail,
                            process_begin,
                            process_intent
                        from
                            (
                                select
                                    l_vc_deployment_id              deployment_id,
                                    processes.name                  process_name,
                                    upper(substr(l_vc_process_type,
                                                 0,
                                                 length(l_vc_process_type) - 1)) process_type,
                                    '--'                            process_trail,
                                    jt.process_begin,
                                    jt.process_intent
                                from
                                        json_table ( l_response, '$.response[*]' null on empty
                                            columns (
                                                process_begin varchar2 ( 400 ) path '$.begin',
                                                process_intent varchar2 ( 400 ) path '$.intent'
                                            )
                                        )
                                    jt
                            )
                    ) rest_src on ( pr.deployment_id = rest_src.deployment_id
                                    and pr.process_name = rest_src.process_name )
                    when matched then update
                    set pr.process_type = rest_src.process_type,
                        pr.process_trail = rest_src.process_trail,
                        pr.process_begin = rest_src.process_begin,
                        pr.process_intent = rest_src.process_intent
                    when not matched then
                    insert (
                        deployment_id,
                        process_name,
                        process_type,
                        process_trail,
                        process_begin,
                        process_intent )
                    values
                        ( rest_src.deployment_id,
                          rest_src.process_name,
                          rest_src.process_type,
                          rest_src.process_trail,
                          rest_src.process_begin,
                          rest_src.process_intent );

                else
                    dbms_output.put_line('ELSE: Process Type is '
                                         || l_vc_process_type
                                         || ' for Proces Name: '
                                         || processes.name || chr(10));

                    merge into ggops_processes pr
                    using (
                        select
                            deployment_id,
                            process_name,
                            process_type,
                            process_source_trail
                        from
                            (
                                select
                                    l_vc_deployment_id                              deployment_id,
                                    processes.name                                  process_name,
                                    upper(substr(l_vc_process_type,
                                                 0,
                                                 length(l_vc_process_type) - 1))                 process_type,
                                    jt.process_target_trail                         process_target_trail,
                                    substr(jt.process_source_trail,
                                           instr(jt.process_source_trail, '=') + 1) process_source_trail
                                from
                                        json_table ( l_response, '$.response[*]' null on empty
                                            columns (
                                                process_target_trail varchar2 ( 400 ) path '$.target.uri',
                                                process_source_trail varchar2 ( 400 ) path '$.source.uri'
                                            )
                                        )
                                    jt
                            )
                    ) rest_src on ( pr.deployment_id = rest_src.deployment_id
                                    and pr.process_name = rest_src.process_name )
                    when matched then update
                    set pr.process_type = rest_src.process_type,
                        pr.process_trail = rest_src.process_source_trail
                    when not matched then
                    insert (
                        deployment_id,
                        process_name,
                        process_type,
                        process_trail )
                    values
                        ( rest_src.deployment_id,
                          rest_src.process_name,
                          rest_src.process_type,
                          rest_src.process_source_trail );

                    dbms_output.put_line('Paths' || chr(10));
                    merge into ggops_paths pa
                    using (
                        select
                            process_id,
                            path_name,
                            path_source_trail,
                            path_target_trail
                        from
                            (
                                select
                                    pr.process_id,
                                    jt.path_name         path_name,
                                    jt.path_source_trail path_source_trail,
                                    jt.path_target_trail path_target_trail
                                from
                                        json_table ( l_response, '$.response[*]' null on empty
                                            columns (
                                                path_name varchar2 ( 400 ) path '$.name',
                                                path_source_trail varchar2 ( 400 ) path '$.source.uri',
                                                path_target_trail varchar2 ( 400 ) path '$.target.uri'
                                            )
                                        )
                                    jt,
                                        ggops_processes pr --, GGOPS_CREDENTIALS CR, GGOPS_PROCESSES PR
                                where
                                        pr.deployment_id = l_vc_deployment_id
                                    and pr.process_name = processes.name
                            )
                    ) rest_src on ( pa.process_id = rest_src.process_id )
                    when matched then update
                    set pa.source_uri = rest_src.path_source_trail,
                        pa.target_uri = rest_src.path_target_trail
                    when not matched then
                    insert (
                        process_id,
                        path_name,
                        source_uri,
                        target_uri )
                    values
                        ( rest_src.process_id,
                          rest_src.path_name,
                          rest_src.path_source_trail,
                          rest_src.path_target_trail );

                    dbms_output.put_line(sqlerrm);
                end if;

                dbms_output.put_line('Params' || chr(10));
                merge into ggops_configuration_files cf
                using (
                    select
                        process_id,
                        regexp_replace(
                            replace(configuration,
                                    '",',
                                    chr(10)),
                            '\[|\]|"',
                            ''
                        ) configuration
                    from
                        (
                            select
                                pr.process_id,
                                jt.configuration -- , jt.DOMAIN_NAME, jt.USER_ALIAS
                            from
                                    json_table ( l_response, '$.response[*]' null on empty
                                        columns (
                                            configuration varchar2 ( 4000 ) format json without wrapper path '$.config'
                                        )
                                    )
                                jt,
                                    ggops_processes pr --, GGOPS_CREDENTIALS CR, GGOPS_PROCESSES PR
                            where
                                    pr.deployment_id = l_vc_deployment_id
                                and pr.process_name = processes.name
                        )
                ) rest_src on ( cf.process_id = rest_src.process_id )
                when matched then update
                set cf.configuration = rest_src.configuration
                when not matched then
                insert (
                    process_id,
                    configuration )
                values
                    ( rest_src.process_id,
                      rest_src.configuration );

                dbms_output.put_line(sqlerrm);
            end loop;
        end if;

    end replication;
-- =============================================
-- Procedure:      MIGRATE
-- Description: Migrate GoldenGate MSA Deployment Process from one Deployment to Compatible Deployment [ADMIN,DIST,RCVR]
-- Parameters:
--      @l_vc_process_id         - The GoldenGare MSA process ID to be migrated
--      @l_vc_service            - The GoldenGare MSA service [adminsrvr,distsrvr,recvsrvr]
-- Returns:           
-- =============================================
    procedure migrate (
        l_n_process_id in number,
        l_vc_service   in varchar2
    ) as

        l_n_host_id        number;
        l_vc_host_addr     varchar2(1000);
        l_vc_host_creds    varchar2(256);
        l_n_deployment_id  number;
        l_vc_deployment    varchar2(256);
        l_vc_process_name  varchar2(100);
        l_vc_process_type  varchar2(100);
        l_vc_service_url   varchar2(4000);
        l_response         clob;
        l_json_text        varchar2(4000);
        l_json_request     varchar2(4000);
        v_sql_proc_config  varchar2(4000) := 'with rws as'
                                            || ' (select translate(configuration, CHR(10) || CHR(13), '','') request'
                                            || ' from ggops_configuration_files gf where gf.process_id = '
                                            || l_n_process_id
                                            || ')'
                                            || ' select json_arrayagg( regexp_substr(request, ''[^,]+'' ,1,level)) val'
                                            || ' from rws connect by level <= length (regexp_replace(request, ''[^,]+'')) +1';
        v_sql_proc_request varchar2(4000);
    begin
        select
            h.host_id,
            host_address,
            replace(host_credential, ' ', '_'),
            d.deployment_id,
            d.deployment_name,
            p.process_name,
            lower(p.process_type || 's')
        into
            l_n_host_id,
            l_vc_host_addr,
            l_vc_host_creds,
            l_n_deployment_id,
            l_vc_deployment,
            l_vc_process_name,
            l_vc_process_type
        from
            ggops_hosts       h,
            ggops_deployments d,
            ggops_processes   p
        where
                h.host_id = d.host_id
            and d.deployment_id = p.deployment_id
            and p.process_id = l_n_process_id;

        l_vc_service_url := '/services/'
                            || l_vc_deployment
                            || '/'
                            || l_vc_service
                            || '/v2/'
                            || l_vc_process_type;

        dbms_output.put_line('*******' || chr(10));
        dbms_output.put_line(v_sql_proc_config || chr(10));
        dbms_output.put_line('*******' || chr(10));
        execute immediate v_sql_proc_config
        into l_json_text;
        dbms_output.put_line('*******' || chr(10));
        dbms_output.put_line(l_json_text || chr(10));
        dbms_output.put_line('*******' || chr(10));
 
        --json_object(''tranlogs'' value ''classic''),'

        v_sql_proc_request := 'select json_object('
                              || '''config'' value '''
                              || l_json_text
                              || ''','
                              || '''source'' value ''tranlogs'','
                              || '''credentials'' value json_object( ''alias'' value cr.user_alias, ''domain'' value do.domain_name),'
                              || '''registration'' value ''default'','
                              || '''begin'' value ''now'','
                              || '''targets'' value json_array(json_object (''name'' value gp.process_trail)) ) json_request'
                              || ' from ggops_processes gp, ggops_configuration_files gf, ggops_credential_domains do, ggops_credentials cr'
                              || ' where gp.process_id = gf.process_id and gp.deployment_id = do.deployment_id and cr.credential_domain_id = do.domain_id and gp.process_id = '
                              || l_n_process_id
                              || 'and rownum = 1';

        dbms_output.put_line('*******' || chr(10));
        dbms_output.put_line(v_sql_proc_request || chr(10));
        dbms_output.put_line('*******' || chr(10));
        execute immediate v_sql_proc_request
        into l_json_request;
        dbms_output.put_line('*******' || chr(10));
        dbms_output.put_line(l_json_request || chr(10));
        dbms_output.put_line('*******' || chr(10));
        l_json_request := replace(l_json_request, '\\\\', '\\"');
        l_json_request := replace(l_json_request, '\"', '"');
        l_json_request := replace(l_json_request, '"[', '[');
        l_json_request := replace(l_json_request, ']"', ']');
        dbms_output.put_line(l_json_request || chr(10));
        dbms_output.put_line('*******' || chr(10));
        dbms_output.put_line('*******' || chr(10));
        dbms_output.put_line('https://'
                             || l_vc_host_addr
                             || l_vc_service_url
                             || '/'
                             || l_vc_process_name || chr(10));

        dbms_output.put_line('*******' || chr(10));
 
 
        -- GET Build Info
        apex_ogg_msa.rest_utl(
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => 'https://'
                        || l_vc_host_addr
                        || l_vc_service_url
                        || '/'
                        || l_vc_process_name,
            l_vc_method     => 'POST',
            l_vc_request    => l_json_request,
            l_response      => l_response
        );

    end migrate;
 
-- =============================================
-- Procedure:      TRANDATA
-- Description: Workwith GoldenGate MSA Deployment TRANDATA configuration
-- Parameters:
--      @l_vc_host               - Name of the GoldenGate deployment host
--      @l_vc_deployment         - Name of the GoldenGate deployment
--      @l_vc_credential_id      - ID of the credential alias used to connect
--      @l_vc_tableSpec          - Name of the table [SCHEMA.TABLENAME - Supports Wildcards for table name *]
--      @l_vc_method             - The activity to perform [LIST, GET, POST (CREATE), PUT (REPLACE), DELETE] 
-- Returns: @l_curr_trandata     - The current tables with supplemental logging enabled
-- =============================================
    procedure trandata (
        l_vc_host          in varchar2 default null,
        l_vc_deployment    in varchar2 default null,
        l_vc_credential_id number,
        l_vc_tablespec     in varchar2 default null,
        l_vc_method        in varchar2 default 'POST',
        l_curr_trandata    out varchar2
    ) as

        l_vc_host_addr    varchar2(1000);
        l_vc_host_creds   varchar2(256);
        l_vc_host_url     varchar2(4000);
        l_n_deployment_id number;
        l_vc_cred_alias   varchar2(256);
        l_vc_service_url  varchar2(4000);
        l_json_text       varchar2(4000);
        l_json_request    varchar2(4000);
        l_response        clob;
    begin
 
        --dbms_lob.createtemporary(l_curr_trandata, TRUE);

        select
            host_address,
            replace(host_credential, ' ', '_'),
            do.domain_name
            || '.'
            || cr.user_alias domain_alias
        into
            l_vc_host_addr,
            l_vc_host_creds,
            l_vc_cred_alias
        from
            ggops_hosts              h,
            ggops_deployments        d,
            ggops_credentials        cr,
            ggops_credential_domains do
        where
                h.host_id = d.host_id
            and cr.credential_domain_id = do.domain_id
            and d.deployment_id = do.deployment_id
            and cr.user_id = l_vc_credential_id
            and h.host_name = l_vc_host
            and d.deployment_name = l_vc_deployment;

        l_vc_service_url := '/services/'
                            || l_vc_deployment
                            || '/adminsrvr/v2/connections/'
                            || l_vc_cred_alias
                            || '/trandata/table';
        l_vc_host_url := 'https://'
                         || l_vc_host_addr
                         || l_vc_service_url;
        select
            json_object(
                'operation' value 'info',
                'tableName' value l_vc_tablespec
            )
        into l_json_request
        from
            dual;
 
        -- GET Info
        apex_ogg_msa.rest_utl(
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => l_vc_host_url,
            l_vc_method     => 'POST',
            l_vc_request    => l_json_request,
            l_response      => l_response
        );

        dbms_output.put_line('Service Response: '
                             || l_response || chr(10));
 
        --FOR tableNames in 
        --(
        select
            listagg(name,
                    chr(10))
        into l_curr_trandata
        from
            (
                select
                    jt.table_names name
                from
                        json_table ( l_response, '$.response.tables[*]' null on empty
                            columns (
                                table_names varchar2 ( 4000 ) path '$.tableName'
                            )
                        )
                    jt
            );

    end trandata;
 
-- Private procedures
-- =============================================
-- Procedure:      MERGE_DEPLOYMENTS
-- Description: Saving GoldenGate MSA Deployment(s) configuration
-- Parameters:
--      @l_vc_host_id          - ID of the GoldenGate deployment host
--      @l_vc_build_title      - Title meta of the connected GoldenGate Service Manager
--      @l_vc_build_label      - Version Label meta of the connected GoldenGate Service Manager
--      @l_vc_build_platform   - Platform meta of the connected GoldenGate Service Manager
--      @l_response            - The MSA json response to the List Deployments API
-- Returns: 
-- =============================================
    procedure merge_deployments (
        l_vc_host_id        varchar2 default null,
        l_vc_build_title    varchar2 default null,
        l_vc_build_label    varchar2 default null,
        l_vc_build_platform varchar2 default null,
        l_response          clob default null
    ) as
    begin
        dbms_output.put_line('Merging Deployments' || chr(10));
        dbms_output.put_line('*******' || chr(10));
        merge into ggops_deployments dp
        using (
            select
                l_vc_host_id host_id,
                name         deployment_name
            from
                (
                    select
                        name
                    from
                            json_table ( l_response, '$.response.items[*]' null on empty
                                columns (
                                    name varchar2 ( 400 ) path '$.name'
                                )
                            )
                        jt
                    where
                        name != 'ServiceManager'
                )
        ) rest_src on ( dp.host_id = rest_src.host_id
                        and dp.deployment_name = rest_src.deployment_name )
        when not matched then
        insert (
            dp.host_id,
            dp.deployment_name,
            dp.deployment_title,
            dp.deployment_label,
            dp.deployment_platform )
        values
            ( rest_src.host_id,
              rest_src.deployment_name,
              l_vc_build_title,
              l_vc_build_label,
              l_vc_build_platform );

        commit;
        dbms_output.put_line('Commited Deployments' || chr(10));
        dbms_output.put_line('*******' || chr(10));
    end merge_deployments;
 
-- =============================================
-- Procedure:      MERGE_CREDENTIALS
-- Description: Saving GoldenGate MSA Deployment credentials from the associated process
-- Parameters:
--      @l_vc_deployment_id    - ID of the GoldenGate deployment
--      @l_host_url            - Host Url -- /services/<DEPLOYMENT>/adminsrvr/v2/credentials/<DOMAIN>/<ALIAS>
--      @l_vc_host_creds       - APEX Web Credential static id to connect to the GoldenGate deployment APIs
--      @l_response            - The MSA json response to the List Deployments API
-- Returns: 
-- =============================================
    procedure merge_credentials (
        l_vc_deployment_id varchar2 default null,
        l_vc_host_url      varchar2 default null,
        l_vc_host_creds    varchar2 default null,
        l_response         clob default null
    ) as
        l_vc_ogg_domain varchar2(4000);
        l_vc_ogg_alias  varchar2(4000);
        l_cred_response clob;
    begin
        dbms_output.put_line('Merging Credentials' || chr(10));
        dbms_output.put_line('*******' || chr(10));
        merge into ggops_credential_domains cd
        using (
            select
                domain_name
            from
                json_table ( l_response, '$.response[*]' null on empty
                    columns (
                        domain_name varchar2 ( 400 ) path '$.credentials.domain'
                    )
                )
        ) rest_src on ( cd.deployment_id = l_vc_deployment_id
                        and cd.domain_name = rest_src.domain_name )
        when not matched then
        insert (
            deployment_id,
            domain_name )
        values
            ( l_vc_deployment_id,
              rest_src.domain_name );

        select
            jt.domain_name,
            jt.user_alias
        into
            l_vc_ogg_domain,
            l_vc_ogg_alias
        from
                json_table ( l_response, '$.response[*]' null on empty
                    columns (
                        domain_name varchar2 ( 400 ) path '$.credentials.domain',
                        user_alias varchar2 ( 400 ) path '$.credentials.alias'
                    )
                )
            jt;
 
            -- GET Info
        apex_ogg_msa.rest_utl(
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => l_vc_host_url
                        || '/adminsrvr/v2/credentials/'
                        || l_vc_ogg_domain
                        || '/'
                        || l_vc_ogg_alias,
            l_vc_method     => 'GET',
            l_response      => l_cred_response
        );

        merge into ggops_credentials cr
        using (
            select
                domain_id,
                user_alias,
                connectuser,
                'notAVal1dPa55!' connectpassword
            from
                (
                    select
                        cd.domain_id    domain_id,
                        l_vc_ogg_domain domain_name,
                        l_vc_ogg_alias  user_alias,
                        jt.user_id      connectuser
                    from
                            json_table ( l_cred_response, '$.response[*]' null on empty
                                columns (
                                    user_id varchar2 ( 1000 ) path '$.userid'
                                )
                            )
                        jt,
                            ggops_credential_domains cd
                    where
                            cd.domain_name = l_vc_ogg_domain
                        and cd.deployment_id = l_vc_deployment_id
                )
        ) rest_src on ( cr.credential_domain_id = rest_src.domain_id
                        and cr.user_alias = rest_src.user_alias )
        when not matched then
        insert (
            credential_domain_id,
            user_alias,
            connectuser,
            onnectpassword )
        values
            ( rest_src.domain_id,
              rest_src.user_alias,
              rest_src.connectuser,
              rest_src.connectpassword );

        commit;
        dbms_output.put_line('Commited Credentials' || chr(10));
        dbms_output.put_line('*******' || chr(10));
    end merge_credentials;
 
-- =============================================
-- Procedure:      MERGE_PROCESSES
-- Description: Saving GoldenGate MSA Deployment Processes configuration
-- Parameters:
--      @l_vc_param            - ID of the GoldenGate deployment host
--      @l_response            - The MSA json response to the List Deployments API
-- Returns: 
-- =============================================
    procedure merge_processes (
        l_vc_process_name          varchar2 default null,
        l_vc_process_type          varchar2 default null,
        l_vc_deployment_id         number,
        l_vc_non_oracle_domain     varchar2 default null,
        l_vc_non_oracle_credential varchar2 default null,
        l_response                 clob default null
    ) as
    begin
        dbms_output.put_line('Merging _' || chr(10));
        dbms_output.put_line('*******' || chr(10));
        merge into ggops_processes pr
        using (
            select
                deployment_id,
                process_name,
                process_type,
                process_trail,
                process_begin,
                process_intent,
                credential_id
            from
                (
                    select
                        cd.deployment_id                        deployment_id,
                        l_vc_process_name                       process_name,
                        upper(substr(l_vc_process_type,
                                     0,
                                     length(l_vc_process_type) - 1))         process_type,
                        nvl(jt.process_target_trail, jt.process_target_uri)
                        || nvl(jt.process_source_trail,
                               substr(jt.process_source_uri,
                                      instr(jt.process_source_uri, '=') + 1)) process_trail,
                        jt.domain_name,
                        jt.user_alias,
                        jt.process_begin,
                        jt.process_intent,
                        cr.user_id                              credential_id
                    from
                            json_table ( l_response, '$.response[*]' null on empty
                                columns (
                                    process_target_trail varchar2 ( 400 ) path '$.targets.name',
                                    process_target_uri varchar2 ( 400 ) path '$.target.uri',
                                    process_source_trail varchar2 ( 400 ) path '$.source.name',
                                    process_source_uri varchar2 ( 400 ) path '$.source.uri',
                                    domain_name varchar2 ( 400 ) path '$.credentials.domain',
                                    user_alias varchar2 ( 400 ) path '$.credentials.alias',
                                    process_begin varchar2 ( 400 ) path '$.begin',
                                    process_intent varchar2 ( 400 ) path '$.intent'
                                )
                            )
                        jt,
                            ggops_credential_domains cd,
                            ggops_credentials        cr
                    where
                            cd.domain_name = nvl(jt.domain_name, l_vc_non_oracle_domain)
                        and cd.deployment_id = l_vc_deployment_id
                        and cr.credential_domain_id = cd.domain_id
                        and cr.user_alias = nvl(jt.user_alias, l_vc_non_oracle_credential)
                )
        ) rest_src on ( pr.deployment_id = rest_src.deployment_id
                        and pr.process_name = rest_src.process_name )
        when matched then update
        set pr.process_type = rest_src.process_type,
            pr.process_trail = rest_src.process_trail,
            pr.process_begin = rest_src.process_begin,
            pr.process_intent = rest_src.process_intent,
            pr.credential_id = rest_src.credential_id
        when not matched then
        insert (
            deployment_id,
            process_name,
            process_type,
            process_trail,
            process_begin,
            process_intent,
            credential_id )
        values
            ( rest_src.deployment_id,
              rest_src.process_name,
              rest_src.process_type,
              rest_src.process_trail,
              rest_src.process_begin,
              rest_src.process_intent,
              rest_src.credential_id );

        commit;
        dbms_output.put_line('Commited _' || chr(10));
        dbms_output.put_line('*******' || chr(10));
    end merge_processes;
 
 
-- =============================================
-- Procedure:      MERGE_TEMPLATE
-- Description: Saving GoldenGate MSA Deployment(s) configuration
-- Parameters:
--      @l_vc_param            - ID of the GoldenGate deployment host
--      @l_response            - The MSA json response to the List Deployments API
-- Returns: 
-- =============================================
    procedure merge_ (
        l_vc_host_id        varchar2 default null,
        l_vc_build_title    varchar2 default null,
        l_vc_build_label    varchar2 default null,
        l_vc_build_platform varchar2 default null,
        l_response          clob default null
    ) as
    begin
        dbms_output.put_line('Merging _' || chr(10));
        dbms_output.put_line('*******' || chr(10));
        commit;
        dbms_output.put_line('Commited _' || chr(10));
        dbms_output.put_line('*******' || chr(10));
    end merge_;

end;
/

