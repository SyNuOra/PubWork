CREATE OR REPLACE EDITIONABLE PACKAGE "APEX_OGG_MSA" 
-- =============================================
-- Author:      Sydney Nurse@Oracle Switzerland
-- Create date: Covid-19 Pandemic October 2021
-- Description: Build to support the migration of Deployments between GoldenGate MSA Deployments
-- Global Parameters:
--      @      - None
--      
-- =============================================
AS
-- Package Required Variables
-- Package Static Referenced Variables
    s_servmgr       varchar2(100) := '/services/v2';
    s_adminsrvr_uri varchar2(100) := '/adminsrvr/v2';
    s_distsrvr_uri  varchar2(100) := '/distsrvr/v2';
    s_recvsrvr_uri  varchar2(100) := '/recvsrvr/v2';
-- =============================================
-- Package Records Definitions
-- =============================================
    TYPE DEPLOYMENT_TYPE is RECORD
    (
        DEPLOYMENT_ID GGOPS_DEPLOYMENTS.DEPLOYMENT_ID%TYPE,
        DEPLOYMENT_NAME GGOPS_DEPLOYMENTS.DEPLOYMENT_NAME%TYPE,
        DEPLOYMENT_STATUS nvarchar2(400),
        DEPLOYMENT_ENABLED nvarchar2(400),
        DEPLOYMENT_OGGHOME nvarchar2(400),
        DEPLOYMENT_ETCHOME nvarchar2(400),
        DEPLOYMENT_CONFHOME nvarchar2(400)
    );
    TYPE DEPLOYMENT_LIST is TABLE OF DEPLOYMENT_TYPE;
    TYPE PROCESS_TYPE is RECORD
    (
        PROCESS_ID GGOPS_PROCESSES.PROCESS_ID%TYPE,
        PROCESS_NAME GGOPS_PROCESSES.PROCESS_NAME%TYPE,
        PROCESS_TYPE GGOPS_PROCESSES.PROCESS_TYPE%TYPE,
        PROCESS_TRAIL GGOPS_PROCESSES.PROCESS_TRAIL%TYPE
    );
    TYPE PROCESS_LIST is TABLE OF PROCESS_TYPE;
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
    PROCEDURE CREATE_CREDENTIAL 
    (
        l_n_flow_id  in number default null,
        l_vc_credential in varchar2 default null,
        l_vc_user in varchar2 default null,
        l_vc_password in varchar2 default null
    );
-- =============================================
-- Procedure:      UPDATE_CREDENTIAL
-- Description: Updates the credential details an APEX Web Credential used by a GoldenGate MSA Connection
-- Parameters:
--      @l_vc_credential          - Name of the connection Credentials
--      @l_vc_user                - Name of the connection Credentials
--      @l_vc_password            - Name of the connection Credentials
-- Returns:                         
-- =============================================
    procedure UPDATE_CREDENTIAL 
    (
        l_vc_credential in varchar2 default null,
        l_vc_user in varchar2 default null,
        l_vc_password in varchar2 default null
    );
-- =============================================
-- Procedure:      DELETE_CREDENTIAL
-- Description: Deletes the credential details an APEX Web Credential used by a GoldenGate MSA Connection
-- Parameters:
--      @l_n_flow_id             - ID of the current Flow
--      @l_vc_credential          - Name of the connection Credentials
-- Returns:                         
-- =============================================
    procedure DELETE_CREDENTIAL 
    (
        l_n_flow_id  in number default null,
        l_vc_credential in varchar2 default null
    );
-- =============================================
-- Procedure:      REST_UTL
-- Description: Utility to support Rest Calls
-- Parameters:
--      @l_vc_credential         - Name of the connection Credentials to use in the REST request
--      @l_vc_url                - The URL for the REST request 
--      @l_vc_method             - The HTTP method for the REST request
-- Returns: @l_response          - The Rest Response                        
-- =============================================
    procedure REST_UTL
    (
        l_vc_credential in varchar2 default null,
        l_vc_url in varchar2 default null,
        l_vc_method in varchar2 default null,
        l_vc_request in varchar2 default null,
        l_response out clob
    );
-- =============================================
-- Procedure:      DEPLOYMENTS
-- Description: Working with GoldenGate MSA Deployments
-- Parameters:
--      @l_vc_host               - Name of the GoldenGate deployment host
--      @l_vc_deployment         - Name of the GoldenGate deployment
--      @l_vc_method             - The activity to perform [LIST, GET] 
-- Returns:                        
-- =============================================
    procedure DEPLOYMENTS
    (
        l_vc_host in varchar2 default null,
        l_vc_deployment in varchar2 default null,
        l_vc_method in varchar2 default null
    );
-- =============================================
-- Procedure:      REPLICATION
-- Description: Working with GoldenGate MSA Replication Services [ADMIN,DIST,RCVR]
-- Parameters:
--      @l_vc_host               - Name of the GoldenGate deployment host
--      @l_vc_deployment         - Name of the GoldenGate deployment
--      @l_vc_method             - The activity to perform [LIST, GET, POST (CREATE), PUT (REPLACE), DELETE] 
--      @l_vc_service            - The GoldenGare MSA service [adminsrvr,distsrvr,recvsrvr]
--      @l_vc_process            - The GoldenGare MSA process name
-- Returns:                        
-- =============================================
    procedure REPLICATION
    (
        l_vc_host in varchar2 default null,
        l_vc_deployment in varchar2 default null,
        l_vc_method in varchar2 default null,
        l_vc_service in varchar2 default null,
        l_vc_process_type in varchar2 default null,
        l_vc_process in varchar2 default null
    );
-- =============================================
-- Procedure:      MIGRATE
-- Description: Migrate GoldenGate MSA Deployment Process from one Deployment to Compatible Deployment [ADMIN,DIST,RCVR]
-- Parameters:
--      @l_vc_process_id         - The GoldenGare MSA process ID to be migrated
--      @l_vc_service            - The GoldenGare MSA service [adminsrvr,distsrvr,recvsrvr]
-- Returns:                        
-- =============================================
    procedure MIGRATE
    (
        l_n_process_id in number default null,
        l_vc_service in varchar2
    );
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
    procedure TRANDATA
    (
        l_vc_host in varchar2 default null,
        l_vc_deployment in varchar2 default null,
        l_vc_credential_id number default null,
        l_vc_tableSpec in varchar2 default null,
        l_vc_method in varchar2 default 'POST',
        l_curr_trandata out varchar2
    );
end;
/


CREATE OR REPLACE EDITIONABLE PACKAGE BODY "APEX_OGG_MSA" 
-- =============================================
-- Author:      Sydney Nurse@Oracle Switzerland
-- Create date: Covid-19 Pandemic October 2021
-- Description: Build to support the migration of Deployments between GoldenGate MSA Deployments
-- Global Parameters:
--      @      - None
--      
-- =============================================
AS
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
    PROCEDURE CREATE_CREDENTIAL 
    (
        l_n_flow_id  in number,
        l_vc_credential in varchar2,
        l_vc_user in varchar2,
        l_vc_password in varchar2
    )
    AS
    BEGIN
        -- CREATE APEX Web Credential
        wwv_flow_api.create_credential
        (
            p_id        => TRUNC (DBMS_RANDOM.VALUE (0, 100000)),
            p_name      => l_vc_credential,
            p_static_id => replace(l_vc_credential,' ','_'),
            p_authentication_type   =>'BASIC',
            p_namespace =>'',
            p_prompt_on_install     =>true
        );
        APEX_OGG_MSA.UPDATE_CREDENTIAL
        (
            l_vc_credential => l_vc_credential,
            l_vc_user       => l_vc_user,
            l_vc_password   => l_vc_password
        );
    END CREATE_CREDENTIAL;
-- =============================================
-- Procedure:      UPDATE_CREDENTIAL
-- Description: Updates the credential details an APEX Web Credential used by a GoldenGate MSA Connection
-- Parameters:
--      @l_vc_credential          - Name of the connection Credentials
--      @l_vc_user                - Name of the connection Credentials
--      @l_vc_password            - Name of the connection Credentials
-- Returns:                         
-- =============================================
    PROCEDURE UPDATE_CREDENTIAL 
    (
        l_vc_credential in varchar2,
        l_vc_user in varchar2,
        l_vc_password in varchar2
    )
    AS
    BEGIN
        -- UPDATE APEX Web Credential
        apex_credential.set_persistent_credentials 
        (
            p_credential_static_id  => replace(l_vc_credential,' ','_'),
            p_username              => l_vc_user,
            p_password              => l_vc_password 
        );
    END UPDATE_CREDENTIAL;
-- =============================================
-- Procedure:      DELETE_CREDENTIAL
-- Description: Deletes the credential details an APEX Web Credential used by a GoldenGate MSA Connection
-- Parameters:
--      @l_n_flow_id             - ID of the current Flow
--      @l_vc_credential          - Name of the connection Credentials
-- Returns:                         
-- =============================================
    procedure DELETE_CREDENTIAL 
    (
        l_n_flow_id  in number,
        l_vc_credential in varchar2
    )
    AS
    BEGIN
        -- DELETE APEX Web Credential
       /**
        wwv_flow_api.drop_credential
        (
            p_id=> l_n_flow_id,
            p_name=> l_vc_credential,
            p_static_id=> replace(l_vc_credential,' ','_')
        );
        **/
        DBMS_OUTPUT.PUT_LINE('');
    END DELETE_CREDENTIAL;
-- =============================================
-- Procedure:      REST_UTL
-- Description: Utility to support Rest Calls
-- Parameters:
--      @l_vc_credential         - Name of the connection Credentials to use in the REST request
--      @l_vc_url                - The URL for the REST request 
--      @l_vc_method             - The HTTP method for the REST request
-- Returns: @l_response          - The Rest Response                        
-- =============================================
    procedure REST_UTL
    (
        l_vc_credential in varchar2,
        l_vc_url in varchar2,
        l_vc_method in varchar2,
        l_vc_request in varchar2,
        l_response out clob
    )
    AS
    BEGIN
        -- set any required headers for the request (suggested minimum required)
        apex_web_service.g_request_headers.delete();
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';   
        -- response received needs to be parsed
        IF (l_vc_request is NULL)
        THEN
            
            l_response := apex_web_service.make_rest_request(
                p_url => l_vc_url,
                p_http_method => l_vc_method,
                p_credential_static_id => l_vc_credential
            );
        ELSE
            l_response := apex_web_service.make_rest_request(
                p_url => l_vc_url,
                p_http_method => l_vc_method,
                p_credential_static_id => l_vc_credential,
                p_body => to_clob(l_vc_request)
            );
        END IF;
        -- response received needs to be parsed
        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
    END REST_UTL;
-- =============================================
-- Procedure:      DEPLOYMENTS
-- Description: Working with GoldenGate MSA Deployments
-- Parameters:
--      @l_vc_host               - Name of the GoldenGate deployment host
--      @l_vc_deployment         - Name of the GoldenGate deployment
--      @l_vc_method             - The activity to perform [LIST, GET] 
-- Returns:                        
-- =============================================
    procedure DEPLOYMENTS
    (
        l_vc_host in varchar2,
        l_vc_deployment in varchar2,
        l_vc_method in varchar2
    )
    AS
        l_vc_host_id number;
        l_vc_host_addr varchar2(1000);
        l_vc_host_creds varchar2(256);
        l_vc_host_url varchar2(4000);
        l_vc_build_title varchar2(400);
        l_vc_build_dbms varchar2(400);
        l_vc_build_label varchar2(400);
        l_vc_build_platform varchar2(400);
        l_vc_build_version varchar2(400);
        l_vc_deployment_names nvarchar2(400);
        l_vc_deployment_status nvarchar2(400);
        l_vc_deployment_enabled nvarchar2(400);
        l_vc_deployment_ogg_home nvarchar2(400);
        l_vc_deployment_etc_home nvarchar2(400);
        l_vc_deployment_conf_home nvarchar2(400);
        l_response clob;
        l_build_response clob;
    BEGIN
        -- Get Deployments for provided host
        -- Get the Host address and associated credentials
        SELECT host_id, host_address, replace(host_credential,' ','_')
            INTO l_vc_host_id, l_vc_host_addr, l_vc_host_creds
            FROM GGOPS_HOSTS 
            WHERE host_name = l_vc_host;
        
        -- Setup URL for LIST Deployments or GET a Deployment
        CASE 
            WHEN l_vc_deployment = 'metadata-catalog' THEN l_vc_host_url := 'https://' || l_vc_host_addr || s_servmgr || '/' || l_vc_deployment;
            WHEN l_vc_method = 'LIST' THEN l_vc_host_url := 'https://' || l_vc_host_addr || s_servmgr || '/deployments';
            ELSE l_vc_host_url := 'https://' || l_vc_host_addr || s_servmgr || '/deployments' || '/' || l_vc_deployment;
        END CASE;
        dbms_output.put_line('host_creds: ' || l_vc_host_creds || CHR(10));
        dbms_output.put_line('host_uri: ' || l_vc_host_url || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        APEX_OGG_MSA.REST_UTL
        (
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => l_vc_host_url,
            l_vc_method     => 'GET',
            l_response      => l_response
        );
    
        -- Does not handle multiple deployments per MSA installation
        -- Need. implement a cursor in future
        CASE l_vc_method
            WHEN 'LIST' THEN
                MERGE INTO GGOPS_DEPLOYMENTS DP
                USING
                (
                    SELECT l_vc_host_id HOST_ID, NAME DEPLOYMENT_NAME
                    FROM 
                    (
                        SELECT NAME FROM JSON_TABLE
                        (
                            l_response, '$.response.items[*]'
                            NULL ON EMPTY
                            COLUMNS
                                (
                                    NAME varchar2(400) PATH '$.name'
                                )
                        ) jt
                        WHERE name != 'ServiceManager'
                    )
                ) REST_SRC
                ON 
                (
                    DP.HOST_ID = REST_SRC.HOST_ID
                    AND DP.DEPLOYMENT_NAME = REST_SRC.DEPLOYMENT_NAME
                )
                
                WHEN NOT MATCHED
                THEN
                INSERT 
                (
                    DP.HOST_ID,
                    DP.DEPLOYMENT_NAME 
                )
                VALUES
                (
                    REST_SRC.HOST_ID,
                    REST_SRC.DEPLOYMENT_NAME
                );
                COMMIT;
                dbms_output.put_line('Commited Deployments: ' || CHR(10));
                dbms_output.put_line('*******' || CHR(10));
                FOR deps IN
                (
                    SELECT DEPLOYMENT_NAME 
                    FROM GGOPS_DEPLOYMENTS
                    WHERE HOST_ID = l_vc_host_id
                )
                LOOP
 
                    APEX_OGG_MSA.DEPLOYMENTS
                    (
                        l_vc_host => l_vc_host,  
                        l_vc_deployment => deps.DEPLOYMENT_NAME,
                        l_vc_method => 'GET' 
                    );
                END LOOP;
            WHEN 'GET' THEN
                IF l_vc_deployment = 'metadata-catalog' THEN
                    dbms_output.put_line('*******' || CHR(10));
                ELSE
                    dbms_output.put_line('Loading Deployments: ' || l_vc_deployment || CHR(10));
                    dbms_output.put_line('*******' || CHR(10));
 
                    -- GET Build Info
                    APEX_OGG_MSA.REST_UTL
                    (
                        l_vc_credential => l_vc_host_creds,
                        l_vc_url        => 'https://' || l_vc_host_addr || '/services/' || l_vc_deployment || '/adminsrvr/v2/config/summary',
                        l_vc_method     => 'GET',
                        l_response      => l_build_response
                    );
                    
                    select title, dbms,label, platform, version into l_vc_build_title, l_vc_build_dbms, l_vc_build_label, l_vc_build_platform, l_vc_build_version 
                        from json_table
                        (
                            l_build_response, '$.response[*]'
                            NULL ON EMPTY
                            columns
                                (
                                    title varchar2(400) path '$.title',
                                    dbms varchar2(400) path '$.build.dbms',
                                    label varchar2(400) path '$.build.label',
                                    platform varchar2(400) path '$.build.platform',
                                    version varchar2(400) path '$.build.version'
                                )
                        ) jt;           
                    
                    dbms_output.put_line('Build Info - Title: ' || l_vc_build_title || ', DB: ' || l_vc_build_dbms || ', Label: ' || l_vc_build_label || ', Platform: ' || l_vc_build_platform || ', Version: ' || l_vc_build_version  || CHR(10));
                    dbms_output.put_line('*******' || CHR(10));
 
                    MERGE INTO GGOPS_DEPLOYMENTS DP
                    USING
                    (
                        select status, enabled, DEPLOYMENT_OGGHOME, DEPLOYMENT_ETCHOME, DEPLOYMENT_CONFHOME 
                        from json_table
                        (
                            l_response, '$.response[*]'
                            NULL ON EMPTY
                            columns
                                (
                                    status varchar2(400) path '$.status',
                                    enabled varchar2(400) path '$.enabled',
                                    DEPLOYMENT_OGGHOME varchar2(400) path '$.oggHome',
                                    DEPLOYMENT_ETCHOME varchar2(400) path '$.oggEtcHome',
                                    DEPLOYMENT_CONFHOME varchar2(400) path '$.oggConfHome'
                                )
                        )
                    ) REST_SRC
                    ON 
                    (
                        DP.HOST_ID = l_vc_host_id
                        AND DP.DEPLOYMENT_NAME = l_vc_deployment
                    )
                    
                    WHEN MATCHED
                    THEN
                    UPDATE
                        SET DP.DEPLOYMENT_OGGHOME = REST_SRC.DEPLOYMENT_OGGHOME,
                            DP.DEPLOYMENT_ETCHOME = REST_SRC.DEPLOYMENT_ETCHOME,
                            DP.DEPLOYMENT_CONFHOME = REST_SRC.DEPLOYMENT_CONFHOME,
                            DP.DEPLOYMENT_TITLE = l_vc_build_title,
                            DP.DEPLOYMENT_LABEL = l_vc_build_label,
                            DP.DEPLOYMENT_PLATFORM = l_vc_build_platform;  
                    COMMIT;
                    
                END IF;
        END CASE;
    END DEPLOYMENTS;
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
    procedure REPLICATION
    (
        l_vc_host in varchar2,
        l_vc_deployment in varchar2,
        l_vc_method in varchar2,
        l_vc_service in varchar2,
        l_vc_process_type in varchar2,
        l_vc_process in varchar2
    )
    AS
        l_vc_host_addr varchar2(1000);
        l_vc_host_creds varchar2(256);
        l_vc_host_url varchar2(4000);
        l_vc_deployment_id number;
        l_vc_deployment_type varchar2(100);
        l_vc_service_url varchar2(4000) := '/services/' || l_vc_deployment || '/' || l_vc_service || '/v2/' || l_vc_process_type;
        l_vc_processes varchar2(400);
        l_vc_config varchar2(4000);
        l_response clob;
        l_vc_process_trail varchar2(4000);
        l_vc_process_begin varchar2(4000);
        l_vc_process_intent varchar2(4000);
        l_vc_credential_id number;
        l_vc_extract_type varchar2(400);
        l_vc_non_oracle_domain varchar2(4000);
        l_vc_non_oracle_credential varchar2(4000);
        /**
        l_vc_cred_domain_id number;
        l_vc_credential_id number;
        l_vc_extracts varchar2(400);
        l_vc_credential varchar2(4000); 
        l_vc_user varchar2(4000);
        l_vc_password varchar2(4000);
        **/
    BEGIN
        
        -- setup URL based on service
        -- Get the Host address and associated credentials
        SELECT hs.host_address, replace(hs.host_credential,' ','_') creds , dp.deployment_id, replace(regexp_substr(dp.deployment_title,'[^ ]+$'),'Manager','Big Data') dep_type
            INTO l_vc_host_addr, l_vc_host_creds, l_vc_deployment_id, l_vc_deployment_type
            FROM GGOPS_HOSTS hs, GGOPS_DEPLOYMENTS dp
            WHERE hs.host_name = l_vc_host
                and dp.deployment_name = l_vc_deployment
                and hs.host_id = dp.host_id;
 
        l_vc_host_url := 'https://' || l_vc_host_addr || l_vc_service_url;
        -- Update URL for a specific process
        IF l_vc_process IS NOT NULL THEN 
            l_vc_host_url := l_vc_host_url || '/' || l_vc_process;
        END IF;
        
        dbms_output.put_line('host_creds: ' || l_vc_host_creds || CHR(10));
        dbms_output.put_line('host_uri: ' || l_vc_host_url || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        APEX_OGG_MSA.REST_UTL
        (
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => l_vc_host_url,
            l_vc_method     => l_vc_method,
            l_response      => l_response
        );
        
        -- response.items[*]
        -- Need to manage multiple processes being returned
        IF l_vc_process IS NULL THEN -- WHEN TRUE THEN LIST
            FOR processes in 
            (
                select name, substr(recvr_path_name,instr(recvr_path_name,'targets/') +8) path_name
                        from json_table
                        (
                            l_response, '$.response.items[*]'
                            NULL ON EMPTY
                            columns
                                (
                                    name varchar2(400) path '$.name',
                                    recvr_path_name varchar2(400) path '$.links[1].href'
                                )
                        ) jt
            )
            LOOP
 
                dbms_output.put_line('Path name: ' || processes.path_name  || CHR(10));
                dbms_output.put_line('*******' || CHR(10)); 
                IF (l_vc_service = 'recvsrvr') THEN
                    l_vc_host_url := 'https://' || l_vc_host_addr || l_vc_service_url || '/' || processes.path_name;
                ELSE
                    l_vc_host_url := 'https://' || l_vc_host_addr || l_vc_service_url || '/' || processes.name;
                END IF;
                
                --'https://' || l_vc_host_addr || '/services/' || l_vc_deployment || '/adminsrvr/v2/' || l_vc_process_type || '/' || processes.name;
                
                dbms_output.put_line('Service url: ' || l_vc_host_url || CHR(10));
                dbms_output.put_line('*******' || CHR(10));
                APEX_OGG_MSA.REST_UTL
                (
                    l_vc_credential => l_vc_host_creds,
                    l_vc_url        => l_vc_host_url,
                    l_vc_method     => l_vc_method,
                    l_response      => l_response
                );
                select extract_type into l_vc_extract_type 
                    from json_table
                        (l_response, '$.response[*]'
                        NULL on EMPTY
                        COLUMNS (extract_type varchar2(400) PATH '$.type'));
 
                -- Big Data Deployments do not have a credential, so need to skip the CRED DOMAIN and CREDS check
                IF (((l_vc_extract_type != 'Source Extract') OR (l_vc_extract_type IS NULL) )AND l_vc_process_type in ('extracts', 'replicats')) THEN
                    dbms_output.put_line('IF: Process Type is ' || l_vc_process_type || ' for Proces Name: ' || processes.name || CHR(10));
                    
 
                    IF ((l_vc_extract_type != 'Source Extract') OR (l_vc_extract_type IS NULL)) THEN 
                        dbms_output.put_line('Extracts' || CHR(10));
 
                        IF (l_vc_deployment_type != 'Oracle' AND l_vc_process_type = 'replicats') THEN
                            select regexp_substr(config, '(USERIDALIAS[[:space:]])([[:alpha:]]+[^,])',1,1,null,2)
                            , regexp_substr(config, '(DOMAIN[[:space:]])([[:alpha:]]+)',1,1,null,2) 
                            into l_vc_non_oracle_credential, l_vc_non_oracle_domain
                            from json_table
                                (
                                    l_response, '$.response[*]'
                                NULL ON EMPTY
                                columns
                                    (
                                        config varchar2(4000) FORMAT JSON WITHOUT WRAPPER PATH '$.config'
                                    )
                            ) jt;
                            dbms_output.put_line('domain:useralias = ' || l_vc_non_oracle_domain || ':' || l_vc_non_oracle_credential || CHR(10));
                        END IF;
 
 
                        MERGE INTO GGOPS_CREDENTIAL_DOMAINS CD
                        USING
                        (
                            SELECT nvl(DOMAIN, l_vc_non_oracle_domain) DOMAIN_NAME
                            FROM JSON_TABLE
                            (
                                l_response, '$.response[*]'
                                NULL ON EMPTY
                                COLUMNS
                                (
                                    DOMAIN varchar2(400) PATH '$.credentials.domain'
                                )
                            )
                        ) REST_SRC
                        ON
                        (
                            CD.DEPLOYMENT_ID = l_vc_deployment_id
                            AND CD.DOMAIN_NAME = REST_SRC.DOMAIN_NAME
                        )
                        WHEN NOT MATCHED
                        THEN
                        INSERT 
                        (
                            DEPLOYMENT_ID,
                            DOMAIN_NAME
                        )
                        VALUES
                        (
                            l_vc_deployment_id,
                            REST_SRC.DOMAIN_NAME
                        );
                        dbms_output.put_line('Credentials' || CHR(10));
                        MERGE INTO GGOPS_CREDENTIALS CR
                        USING
                        (
                            SELECT DOMAIN_ID, USER_ALIAS, 'DEFAULT' CONNECTUSER, 'notAVal1dPa55!' CONNECTPASSWORD
                            FROM
                            (
                                SELECT  CD.DOMAIN_ID DOMAIN_ID, nvl(jt.DOMAIN_, l_vc_non_oracle_domain) DOMAIN_ALIAS, nvl(jt.USER_, l_vc_non_oracle_credential) USER_ALIAS 
                                FROM JSON_TABLE
                                (
                                    l_response, '$.response[*]'
                                    NULL ON EMPTY
                                    COLUMNS
                                        (
                                            DOMAIN_ varchar2(400) PATH '$.credentials.domain',
                                            USER_ varchar2(400) PATH '$.credentials.alias'
                                        )
                                ) jt, GGOPS_CREDENTIAL_DOMAINS CD
                                WHERE CD.DOMAIN_NAME = nvl(jt.DOMAIN_, l_vc_non_oracle_domain)
                                AND CD.DEPLOYMENT_ID = l_vc_deployment_id
                            )
                        ) REST_SRC
                        ON
                        (
                            CR.CREDENTIAL_DOMAIN_ID = REST_SRC.DOMAIN_ID
                            AND CR.USER_ALIAS = REST_SRC.USER_ALIAS
                        )
                        WHEN NOT MATCHED
                        THEN 
                        INSERT
                        (
                            CREDENTIAL_DOMAIN_ID,
                            USER_ALIAS,
                            CONNECTUSER,
                            ONNECTPASSWORD
                        )
                        VALUES
                        (
                            REST_SRC.DOMAIN_ID,
                            REST_SRC.USER_ALIAS,
                            REST_SRC.CONNECTUSER,
                            REST_SRC.CONNECTPASSWORD
                        );
                        
                        MERGE INTO GGOPS_PROCESSES PR
                        USING
                        (
                            SELECT DEPLOYMENT_ID, PROCESS_NAME, PROCESS_TYPE, PROCESS_TRAIL,PROCESS_BEGIN, PROCESS_INTENT, CREDENTIAL_ID
                            FROM
                            (
                                SELECT CD.DEPLOYMENT_ID DEPLOYMENT_ID, processes.name PROCESS_NAME, UPPER(SUBSTR(l_vc_process_type,0,LENGTH(l_vc_process_type) - 1)) PROCESS_TYPE, jt.PROCESS_TARGET_TRAIL || jt.PROCESS_SOURCE_TRAIL PROCESS_TRAIL, jt.DOMAIN_NAME, jt.USER_ALIAS, jt.PROCESS_BEGIN, jt.PROCESS_INTENT, CR.USER_ID CREDENTIAL_ID
                                FROM JSON_TABLE
                                (
                                    l_response, '$.response[*]'
                                    NULL ON EMPTY
                                    COLUMNS
                                        (
                                            PROCESS_TARGET_TRAIL varchar2(400) PATH '$.targets.name',
                                            PROCESS_SOURCE_TRAIL varchar2(400) PATH '$.source.name',
                                            DOMAIN_NAME varchar2(400) PATH '$.credentials.domain',
                                            USER_ALIAS varchar2(400) PATH '$.credentials.alias',
                                            PROCESS_BEGIN varchar2(400) PATH '$.begin',
                                            PROCESS_INTENT varchar2(400) PATH '$.intent'
                                        )
                                ) jt, GGOPS_CREDENTIAL_DOMAINS CD, GGOPS_CREDENTIALS CR
                                    WHERE CD.DOMAIN_NAME = nvl(jt.DOMAIN_NAME, l_vc_non_oracle_domain)
                                    AND CD.DEPLOYMENT_ID = l_vc_deployment_id
                                    AND CR.CREDENTIAL_DOMAIN_ID = CD.DOMAIN_ID
                                    AND CR.USER_ALIAS = nvl(jt.USER_ALIAS, l_vc_non_oracle_credential)
                            )
                        ) REST_SRC
                        ON
                        (
                            PR.DEPLOYMENT_ID = REST_SRC.DEPLOYMENT_ID
                            AND PR.PROCESS_NAME = REST_SRC.PROCESS_NAME
                        )
                        WHEN MATCHED
                        THEN
                        UPDATE
                            SET 
                            PR.PROCESS_TYPE = REST_SRC.PROCESS_TYPE,
                            PR.PROCESS_TRAIL = REST_SRC.PROCESS_TRAIL,
                            PR.PROCESS_BEGIN = REST_SRC.PROCESS_BEGIN,
                            PR.PROCESS_INTENT = REST_SRC.PROCESS_INTENT,
                            PR.CREDENTIAL_ID = REST_SRC.CREDENTIAL_ID
                        
                        WHEN NOT MATCHED
                        THEN 
                        INSERT
                        (
                            DEPLOYMENT_ID,
                            PROCESS_NAME,
                            PROCESS_TYPE,
                            PROCESS_TRAIL,
                            PROCESS_BEGIN,
                            PROCESS_INTENT,
                            CREDENTIAL_ID
                        )
                        VALUES
                        (
                            REST_SRC.DEPLOYMENT_ID,
                            REST_SRC.PROCESS_NAME,
                            REST_SRC.PROCESS_TYPE,
                            REST_SRC.PROCESS_TRAIL,
                            REST_SRC.PROCESS_BEGIN,
                            REST_SRC.PROCESS_INTENT,
                            REST_SRC.CREDENTIAL_ID
                        );
                        
                    END IF;
                -- Else Try to get Everything else that does not ha credentials
                
                ELSIF (l_vc_extract_type = 'Source Extract')  THEN
 
                    dbms_output.put_line('ELSIF: Process Type is ' || l_vc_process_type || ' for Proces Name: ' || processes.name || CHR(10));
                    MERGE INTO GGOPS_PROCESSES PR
                    USING
                    (
                        SELECT DEPLOYMENT_ID, PROCESS_NAME, PROCESS_TYPE, PROCESS_TRAIL,PROCESS_BEGIN, PROCESS_INTENT
                        FROM
                        (
                            SELECT l_vc_deployment_id DEPLOYMENT_ID, processes.name PROCESS_NAME, UPPER(SUBSTR(l_vc_process_type,0,LENGTH(l_vc_process_type) - 1)) PROCESS_TYPE, '--' PROCESS_TRAIL, jt.PROCESS_BEGIN, jt.PROCESS_INTENT
                            FROM JSON_TABLE
                            (
                                l_response, '$.response[*]'
                                NULL ON EMPTY
                                COLUMNS
                                    (
                                        PROCESS_BEGIN varchar2(400) PATH '$.begin',
                                        PROCESS_INTENT varchar2(400) PATH '$.intent'
                                    )
                            ) jt
                        )
                    ) REST_SRC
                    ON
                    (
                        PR.DEPLOYMENT_ID = REST_SRC.DEPLOYMENT_ID
                        AND PR.PROCESS_NAME = REST_SRC.PROCESS_NAME
                    )
                    WHEN MATCHED
                    THEN
                    UPDATE
                        SET 
                        PR.PROCESS_TYPE = REST_SRC.PROCESS_TYPE,
                        PR.PROCESS_TRAIL = REST_SRC.PROCESS_TRAIL,
                        PR.PROCESS_BEGIN = REST_SRC.PROCESS_BEGIN,
                        PR.PROCESS_INTENT = REST_SRC.PROCESS_INTENT
                    
                    WHEN NOT MATCHED
                    THEN 
                    INSERT
                    (
                        DEPLOYMENT_ID,
                        PROCESS_NAME,
                        PROCESS_TYPE,
                        PROCESS_TRAIL,
                        PROCESS_BEGIN,
                        PROCESS_INTENT
                    )
                    VALUES
                    (
                        REST_SRC.DEPLOYMENT_ID,
                        REST_SRC.PROCESS_NAME,
                        REST_SRC.PROCESS_TYPE,
                        REST_SRC.PROCESS_TRAIL,
                        REST_SRC.PROCESS_BEGIN,
                        REST_SRC.PROCESS_INTENT
                    );
                
                ELSE
                    
                    dbms_output.put_line('ELSE: Process Type is ' || l_vc_process_type || ' for Proces Name: ' || processes.name || CHR(10));
                    MERGE INTO GGOPS_PROCESSES PR
                    USING
                    (
                        SELECT DEPLOYMENT_ID, PROCESS_NAME, PROCESS_TYPE, PROCESS_SOURCE_TRAIL
                        FROM
                        (
                            SELECT l_vc_deployment_id DEPLOYMENT_ID, processes.name PROCESS_NAME, UPPER(SUBSTR(l_vc_process_type,0,LENGTH(l_vc_process_type) - 1)) PROCESS_TYPE, jt.PROCESS_TARGET_TRAIL PROCESS_TARGET_TRAIL, SUBSTR(jt.PROCESS_SOURCE_TRAIL,INSTR(jt.PROCESS_SOURCE_TRAIL,'=')+1) PROCESS_SOURCE_TRAIL
                            FROM JSON_TABLE
                            (
                                l_response, '$.response[*]'
                                NULL ON EMPTY
                                COLUMNS
                                    (
                                        PROCESS_TARGET_TRAIL varchar2(400) PATH '$.target.uri',
                                        PROCESS_SOURCE_TRAIL varchar2(400) PATH '$.source.uri'
                                    )
                            ) jt
                        )
                    ) REST_SRC
                    ON
                    (
                        PR.DEPLOYMENT_ID = REST_SRC.DEPLOYMENT_ID
                        AND PR.PROCESS_NAME = REST_SRC.PROCESS_NAME
                    )
                    WHEN MATCHED
                    THEN
                    UPDATE
                        SET 
                        PR.PROCESS_TYPE = REST_SRC.PROCESS_TYPE,
                        PR.PROCESS_TRAIL = REST_SRC.PROCESS_SOURCE_TRAIL
                    
                    WHEN NOT MATCHED
                    THEN 
                    INSERT
                    (
                        DEPLOYMENT_ID,
                        PROCESS_NAME,
                        PROCESS_TYPE,
                        PROCESS_TRAIL
                    )
                    VALUES
                    (
                        REST_SRC.DEPLOYMENT_ID,
                        REST_SRC.PROCESS_NAME,
                        REST_SRC.PROCESS_TYPE,
                        REST_SRC.PROCESS_SOURCE_TRAIL
                    );
 
                    dbms_output.put_line('Paths' || CHR(10));
                    MERGE INTO GGOPS_PATHS PA
                    USING
                    (
                        SELECT PROCESS_ID, PATH_NAME, PATH_SOURCE_TRAIL, PATH_TARGET_TRAIL
                        FROM
                        (
                            SELECT   PR.PROCESS_ID, jt.PATH_NAME PATH_NAME, jt.PATH_SOURCE_TRAIL PATH_SOURCE_TRAIL, jt.PATH_TARGET_TRAIL PATH_TARGET_TRAIL
                            FROM JSON_TABLE
                            (
                                l_response, '$.response[*]'
                                NULL ON EMPTY
                                COLUMNS
                                    (
                                        PATH_NAME varchar2(400) PATH '$.name',
                                        PATH_SOURCE_TRAIL varchar2(400) PATH '$.source.uri',
                                        PATH_TARGET_TRAIL varchar2(400) PATH '$.target.uri'
                                    )
                            ) jt, GGOPS_PROCESSES PR --, GGOPS_CREDENTIALS CR, GGOPS_PROCESSES PR
                                WHERE PR.DEPLOYMENT_ID = l_vc_deployment_id
                                AND PR.PROCESS_NAME = processes.name
                        )
                    ) REST_SRC
                    ON
                    (
                        PA.PROCESS_ID = REST_SRC.PROCESS_ID
                    )    
                    
                    WHEN MATCHED
                    THEN 
                    UPDATE SET PA.SOURCE_URI = REST_SRC.PATH_SOURCE_TRAIL,
                        PA.TARGET_URI = REST_SRC.PATH_TARGET_TRAIL
                    WHEN NOT MATCHED
                    THEN 
                    INSERT
                    (
                        PROCESS_ID,
                        PATH_NAME,
                        SOURCE_URI,
                        TARGET_URI
                    )
                    VALUES
                    (
                        REST_SRC.PROCESS_ID,
                        REST_SRC.PATH_NAME,
                        REST_SRC.PATH_SOURCE_TRAIL,
                        REST_SRC.PATH_TARGET_TRAIL
                    );
                    DBMS_OUTPUT.put_line (SQLERRM);
                END IF;
                
                dbms_output.put_line('Params' || CHR(10));
                MERGE INTO GGOPS_CONFIGURATION_FILES CF
                USING
                (
                    SELECT PROCESS_ID, regexp_replace(replace(CONFIGURATION,'",',CHR(10)),'\[|\]|"','') CONFIGURATION
                    FROM
                    (
                        SELECT   PR.PROCESS_ID, jt.CONFIGURATION -- , jt.DOMAIN_NAME, jt.USER_ALIAS
                        FROM JSON_TABLE
                        (
                            l_response, '$.response[*]'
                            NULL ON EMPTY
                            COLUMNS
                                (
                                    CONFIGURATION varchar2(4000) FORMAT JSON WITHOUT WRAPPER PATH '$.config'
                                )
                        ) jt, GGOPS_PROCESSES PR --, GGOPS_CREDENTIALS CR, GGOPS_PROCESSES PR
                            WHERE PR.DEPLOYMENT_ID = l_vc_deployment_id
                            AND PR.PROCESS_NAME = processes.name
                    )
                ) REST_SRC
                ON
                (
                    CF.PROCESS_ID = REST_SRC.PROCESS_ID
                )    
                
                WHEN MATCHED
                THEN 
                UPDATE SET CF.CONFIGURATION = REST_SRC.CONFIGURATION
                WHEN NOT MATCHED
                THEN 
                INSERT
                (
                    PROCESS_ID,
                    CONFIGURATION
                )
                VALUES
                (
                    REST_SRC.PROCESS_ID,
                    REST_SRC.CONFIGURATION
                );
                DBMS_OUTPUT.put_line (SQLERRM);
                
            END LOOP;
           
            
        END IF;
        
    END REPLICATION;
-- =============================================
-- Procedure:      MIGRATE
-- Description: Migrate GoldenGate MSA Deployment Process from one Deployment to Compatible Deployment [ADMIN,DIST,RCVR]
-- Parameters:
--      @l_vc_process_id         - The GoldenGare MSA process ID to be migrated
--      @l_vc_service            - The GoldenGare MSA service [adminsrvr,distsrvr,recvsrvr]
-- Returns:           
-- =============================================
    procedure MIGRATE
    (
        l_n_process_id in number,
        l_vc_service in varchar2
    )
    AS
        l_n_host_id number;
        l_vc_host_addr varchar2(1000);
        l_vc_host_creds varchar2(256);
 
        l_n_deployment_id number;
        l_vc_deployment varchar2(256);
 
        l_vc_process_name varchar2(100);
        l_vc_process_type varchar2(100);
 
        l_vc_service_url varchar2(4000);
        l_response clob;
 
        l_json_text varchar2(4000);
        l_json_request varchar2(4000);
 
        v_sql_proc_config varchar2(4000) := 'with rws as'
        || ' (select translate(configuration, CHR(10) || CHR(13), '','') request'
        || ' from ggops_configuration_files gf where gf.process_id = '
        || l_n_process_id || ')'
        || ' select json_arrayagg( regexp_substr(request, ''[^,]+'' ,1,level)) val'
        || ' from rws connect by level <= length (regexp_replace(request, ''[^,]+'')) +1';
 
        v_sql_proc_request varchar2(4000);
 
    BEGIN
        select h.host_id, host_address, replace(host_credential,' ','_'), d.deployment_id, d.deployment_name, p.process_name, lower(p.process_type || 's')
        into l_n_host_id, l_vc_host_addr, l_vc_host_creds, l_n_deployment_id, l_vc_deployment, l_vc_process_name, l_vc_process_type
            from ggops_hosts h
            , ggops_deployments d
            , ggops_processes p
            where h.host_id = d.host_id
            and d.deployment_id = p.deployment_id
            and p.process_id = l_n_process_id;
 
        l_vc_service_url := '/services/' || l_vc_deployment || '/' || l_vc_service || '/v2/' || l_vc_process_type;
        
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(v_sql_proc_config || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
 
        execute immediate v_sql_proc_config into l_json_text;
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(l_json_text || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
 
        --json_object(''tranlogs'' value ''classic''),'
 
        v_sql_proc_request := 'select json_object(' 
        || '''config'' value ''' || l_json_text || ''',' 
        || '''source'' value ''tranlogs'',' 
        || '''credentials'' value json_object( ''alias'' value cr.user_alias, ''domain'' value do.domain_name),'
        || '''registration'' value ''default'','
        || '''begin'' value ''now'','
        || '''targets'' value json_array(json_object (''name'' value gp.process_trail)) ) json_request'
        || ' from ggops_processes gp, ggops_configuration_files gf, ggops_credential_domains do, ggops_credentials cr'
        || ' where gp.process_id = gf.process_id and gp.deployment_id = do.deployment_id and cr.credential_domain_id = do.domain_id and gp.process_id = '
        || l_n_process_id || 'and rownum = 1';
 
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(v_sql_proc_request || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
 
        execute immediate v_sql_proc_request into l_json_request;
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(l_json_request || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
 
        l_json_request := replace(l_json_request, '\\\\', '\\"'); 
        l_json_request := replace(l_json_request, '\"', '"');  
        l_json_request := replace(l_json_request, '"[', '[');  
        l_json_request := replace(l_json_request, ']"', ']'); 
 
 
        dbms_output.put_line(l_json_request || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
 
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line('https://' || l_vc_host_addr || l_vc_service_url || '/' || l_vc_process_name || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
 
 
        -- GET Build Info
        APEX_OGG_MSA.REST_UTL
        (
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => 'https://' || l_vc_host_addr || l_vc_service_url || '/' || l_vc_process_name,
            l_vc_method     => 'POST',
            l_vc_request    => l_json_request,
            l_response      => l_response
        );
 
    END MIGRATE;
 
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
    procedure TRANDATA
    (
        l_vc_host in varchar2 default null,
        l_vc_deployment in varchar2 default null,
        l_vc_credential_id number,
        l_vc_tableSpec in varchar2 default null,
        l_vc_method in varchar2 default 'POST',
        l_curr_trandata out varchar2
    )
    AS
 
        l_vc_host_addr varchar2(1000);
        l_vc_host_creds varchar2(256);
        l_vc_host_url varchar2(4000);
 
        l_n_deployment_id number;
        l_vc_cred_alias varchar2(256);
        l_vc_service_url varchar2(4000);
 
        l_json_text varchar2(4000);
        l_json_request varchar2(4000);
        l_response clob;
 
    BEGIN
 
        --dbms_lob.createtemporary(l_curr_trandata, TRUE);
 
        select host_address, replace(host_credential,' ','_'), do.domain_name || '.' || cr.user_alias domain_alias
        into l_vc_host_addr, l_vc_host_creds, l_vc_cred_alias
            from ggops_hosts h, ggops_deployments d, ggops_credentials cr, ggops_credential_domains do
            where h.host_id = d.host_id
            and cr. credential_domain_id = do.domain_id
            and d.deployment_id = do.deployment_id
            and cr.user_id = l_vc_credential_id
            and h.host_name = l_vc_host
            and d.deployment_name = l_vc_deployment;
 
        l_vc_service_url := '/services/' || l_vc_deployment || '/adminsrvr/v2/connections/' || l_vc_cred_alias || '/trandata/table';
        l_vc_host_url := 'https://' || l_vc_host_addr || l_vc_service_url;
 
        select json_object(
            'operation' value 'info',
            'tableName' value l_vc_tableSpec
        ) into l_json_request
        from dual;
 
        -- GET Info
        APEX_OGG_MSA.REST_UTL
        (
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => l_vc_host_url,
            l_vc_method     => 'POST',
            l_vc_request    => l_json_request,
            l_response      => l_response
        );
 
        dbms_output.put_line('Service Response: ' || l_response || CHR(10));
 
        --FOR tableNames in 
        --(
          
        select listagg(name, CHR(10)) into l_curr_trandata
        FROM 
        (
            select jt.table_names name
                from json_table
                (
                    l_response, '$.response.tables[*]'
                    NULL ON EMPTY
                    columns
                        (
                            table_names varchar2(4000) path '$.tableName'
                        )
                ) jt
        );
        
    END TRANDATA;
 
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
    procedure MERGE_DEPLOYMENTS 
    (
        l_vc_host_id varchar2 default null,
        l_vc_build_title varchar2 default null,
        l_vc_build_label  varchar2 default null, 
        l_vc_build_platform varchar2 default null,
        l_response clob default null
    )
    AS
    BEGIN
 
        dbms_output.put_line('Merging Deployments' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        MERGE INTO GGOPS_DEPLOYMENTS DP
            USING
            (
                SELECT l_vc_host_id HOST_ID, NAME DEPLOYMENT_NAME
                FROM 
                (
                    SELECT NAME FROM JSON_TABLE
                    (
                        l_response, '$.response.items[*]'
                        NULL ON EMPTY
                        COLUMNS
                            (
                                NAME varchar2(400) PATH '$.name'
                            )
                    ) jt
                    WHERE name != 'ServiceManager'
                )
            ) REST_SRC
            ON 
            (
                DP.HOST_ID = REST_SRC.HOST_ID
                AND DP.DEPLOYMENT_NAME = REST_SRC.DEPLOYMENT_NAME
            )
            
            WHEN NOT MATCHED
            THEN
            INSERT 
            (
                DP.HOST_ID,
                DP.DEPLOYMENT_NAME,
                DP.DEPLOYMENT_TITLE,
                DP.DEPLOYMENT_LABEL,
                DP.DEPLOYMENT_PLATFORM
            )
            VALUES
            (
                REST_SRC.HOST_ID,
                REST_SRC.DEPLOYMENT_NAME,
                l_vc_build_title,
                l_vc_build_label, 
                l_vc_build_platform
            );
        COMMIT;
        dbms_output.put_line('Commited Deployments' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
    END MERGE_DEPLOYMENTS;
 
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
    procedure MERGE_CREDENTIALS 
    (
        l_vc_deployment_id varchar2 default null,
        l_vc_host_url varchar2 default null,
        l_vc_host_creds varchar2 default null,
        l_response clob default null
    )
    AS
 
        l_vc_ogg_domain varchar2(4000);
        l_vc_ogg_alias varchar2(4000);
        l_cred_response clob;
 
    BEGIN
 
        dbms_output.put_line('Merging Credentials' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        MERGE INTO GGOPS_CREDENTIAL_DOMAINS CD
            USING
            (
                SELECT DOMAIN_NAME
                FROM JSON_TABLE
                (
                    l_response, '$.response[*]'
                    NULL ON EMPTY
                    COLUMNS
                    (
                        DOMAIN_NAME varchar2(400) PATH '$.credentials.domain'
                    )
                )
            ) REST_SRC
            ON
            (
                CD.DEPLOYMENT_ID = l_vc_deployment_id
                AND CD.DOMAIN_NAME = REST_SRC.DOMAIN_NAME
            )
            WHEN NOT MATCHED
            THEN
            INSERT 
            (
                DEPLOYMENT_ID,
                DOMAIN_NAME
            )
            VALUES
            (
                l_vc_deployment_id,
                REST_SRC.DOMAIN_NAME
            );
 
        SELECT  jt.DOMAIN_NAME, jt.USER_ALIAS
            into l_vc_ogg_domain, l_vc_ogg_alias
            FROM JSON_TABLE
            (
                l_response, '$.response[*]'
                NULL ON EMPTY
                COLUMNS
                    (
                        DOMAIN_NAME varchar2(400) PATH '$.credentials.domain',
                        USER_ALIAS varchar2(400) PATH '$.credentials.alias'
                    )
            ) jt;
 
            -- GET Info
        APEX_OGG_MSA.REST_UTL
        (
            l_vc_credential => l_vc_host_creds,
            l_vc_url        => l_vc_host_url || '/adminsrvr/v2/credentials/' || l_vc_ogg_domain || '/' || l_vc_ogg_alias,
            l_vc_method     => 'GET',
            l_response      => l_cred_response
        );
 
        MERGE INTO GGOPS_CREDENTIALS CR
            USING
            (
                SELECT DOMAIN_ID, USER_ALIAS, CONNECTUSER, 'notAVal1dPa55!' CONNECTPASSWORD
                FROM
                (
                    SELECT  CD.DOMAIN_ID DOMAIN_ID, l_vc_ogg_domain DOMAIN_NAME, l_vc_ogg_alias USER_ALIAS, jt.USER_ID CONNECTUSER
                    FROM JSON_TABLE
                    (
                        l_cred_response, '$.response[*]'
                        NULL ON EMPTY
                        COLUMNS
                            (
                                USER_ID varchar2(1000) PATH '$.userid'
                            )
                    ) jt, GGOPS_CREDENTIAL_DOMAINS CD
                    WHERE CD.DOMAIN_NAME = l_vc_ogg_domain
                    AND CD.DEPLOYMENT_ID = l_vc_deployment_id
                )
            ) REST_SRC
            ON
            (
                CR.CREDENTIAL_DOMAIN_ID = REST_SRC.DOMAIN_ID
                AND CR.USER_ALIAS = REST_SRC.USER_ALIAS
            )
            WHEN NOT MATCHED
            THEN 
            INSERT
            (
                CREDENTIAL_DOMAIN_ID,
                USER_ALIAS,
                CONNECTUSER,
                ONNECTPASSWORD
            )
            VALUES
            (
                REST_SRC.DOMAIN_ID,
                REST_SRC.USER_ALIAS,
                REST_SRC.CONNECTUSER,
                REST_SRC.CONNECTPASSWORD
            );
        COMMIT;
        dbms_output.put_line('Commited Credentials' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
    END MERGE_CREDENTIALS;
 
-- =============================================
-- Procedure:      MERGE_PROCESSES
-- Description: Saving GoldenGate MSA Deployment Processes configuration
-- Parameters:
--      @l_vc_param            - ID of the GoldenGate deployment host
--      @l_response            - The MSA json response to the List Deployments API
-- Returns: 
-- =============================================
    procedure MERGE_PROCESSES 
    (
        l_vc_process_name varchar2 default null,
        l_vc_process_type varchar2 default null,
        l_vc_deployment_id number,
        l_vc_non_oracle_domain varchar2 default null,
        l_vc_non_oracle_credential varchar2 default null,
        l_response clob default null
    )
    AS
    BEGIN
 
        dbms_output.put_line('Merging _' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
    
        MERGE INTO GGOPS_PROCESSES PR
        USING
        (
            SELECT DEPLOYMENT_ID, PROCESS_NAME, PROCESS_TYPE, PROCESS_TRAIL,PROCESS_BEGIN, PROCESS_INTENT, CREDENTIAL_ID
            FROM
            (
                SELECT CD.DEPLOYMENT_ID DEPLOYMENT_ID, l_vc_process_name PROCESS_NAME, UPPER(SUBSTR(l_vc_process_type,0,LENGTH(l_vc_process_type) - 1)) PROCESS_TYPE, nvl(jt.PROCESS_TARGET_TRAIL,jt.PROCESS_TARGET_URI) || nvl(jt.PROCESS_SOURCE_TRAIL,SUBSTR(jt.PROCESS_SOURCE_URI,INSTR(jt.PROCESS_SOURCE_URI,'=')+1)) PROCESS_TRAIL, jt.DOMAIN_NAME, jt.USER_ALIAS, jt.PROCESS_BEGIN, jt.PROCESS_INTENT, CR.USER_ID CREDENTIAL_ID
                FROM JSON_TABLE
                (
                    l_response, '$.response[*]'
                    NULL ON EMPTY
                    COLUMNS
                        (
                            PROCESS_TARGET_TRAIL varchar2(400) PATH '$.targets.name',
                            PROCESS_TARGET_URI varchar2(400) PATH '$.target.uri',
                            PROCESS_SOURCE_TRAIL varchar2(400) PATH '$.source.name',
                            PROCESS_SOURCE_URI varchar2(400) PATH '$.source.uri',
                            DOMAIN_NAME varchar2(400) PATH '$.credentials.domain',
                            USER_ALIAS varchar2(400) PATH '$.credentials.alias',
                            PROCESS_BEGIN varchar2(400) PATH '$.begin',
                            PROCESS_INTENT varchar2(400) PATH '$.intent'
                        )
                ) jt, GGOPS_CREDENTIAL_DOMAINS CD, GGOPS_CREDENTIALS CR
                    WHERE CD.DOMAIN_NAME = nvl(jt.DOMAIN_NAME, l_vc_non_oracle_domain)
                    AND CD.DEPLOYMENT_ID = l_vc_deployment_id
                    AND CR.CREDENTIAL_DOMAIN_ID = CD.DOMAIN_ID
                    AND CR.USER_ALIAS = nvl(jt.USER_ALIAS, l_vc_non_oracle_credential)
            )
        ) REST_SRC
        ON
        (
            PR.DEPLOYMENT_ID = REST_SRC.DEPLOYMENT_ID
            AND PR.PROCESS_NAME = REST_SRC.PROCESS_NAME
        )
        WHEN MATCHED
        THEN
        UPDATE
            SET 
            PR.PROCESS_TYPE = REST_SRC.PROCESS_TYPE,
            PR.PROCESS_TRAIL = REST_SRC.PROCESS_TRAIL,
            PR.PROCESS_BEGIN = REST_SRC.PROCESS_BEGIN,
            PR.PROCESS_INTENT = REST_SRC.PROCESS_INTENT,
            PR.CREDENTIAL_ID = REST_SRC.CREDENTIAL_ID
        
        WHEN NOT MATCHED
        THEN 
        INSERT
        (
            DEPLOYMENT_ID,
            PROCESS_NAME,
            PROCESS_TYPE,
            PROCESS_TRAIL,
            PROCESS_BEGIN,
            PROCESS_INTENT,
            CREDENTIAL_ID
        )
        VALUES
        (
            REST_SRC.DEPLOYMENT_ID,
            REST_SRC.PROCESS_NAME,
            REST_SRC.PROCESS_TYPE,
            REST_SRC.PROCESS_TRAIL,
            REST_SRC.PROCESS_BEGIN,
            REST_SRC.PROCESS_INTENT,
            REST_SRC.CREDENTIAL_ID
        );
        COMMIT;
        dbms_output.put_line('Commited _' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
    END MERGE_PROCESSES;
 
 
-- =============================================
-- Procedure:      MERGE_TEMPLATE
-- Description: Saving GoldenGate MSA Deployment(s) configuration
-- Parameters:
--      @l_vc_param            - ID of the GoldenGate deployment host
--      @l_response            - The MSA json response to the List Deployments API
-- Returns: 
-- =============================================
    procedure MERGE_ 
    (
        l_vc_host_id varchar2 default null,
        l_vc_build_title varchar2 default null,
        l_vc_build_label  varchar2 default null, 
        l_vc_build_platform varchar2 default null,
        l_response clob default null
    )
    AS
    BEGIN
 
        dbms_output.put_line('Merging _' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        
            COMMIT;
            dbms_output.put_line('Commited _' || CHR(10));
            dbms_output.put_line('*******' || CHR(10));
    END MERGE_;
 
end;
 
/

