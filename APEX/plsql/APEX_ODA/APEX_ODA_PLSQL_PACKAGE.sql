CREATE OR REPLACE PACKAGE "APEX_ODA" 
-- =============================================
-- Author:      Sydney Nurse@Oracle Switzerland
-- Create date: Covid-19 Pandemic Junly 2021
-- Description: Manages the ODA API Push Data Requests - developed for the Hack Participants APEX to ODA app
-- Global Parameters:
--      @G_OCI_WEB_CREDENTIALS      - OCI connection Credentials
--      @G_ODA_BASE_URL             - ODA connection Base API URL
--      @G_ODA_SKILL_ID             - ODA Skill ID: retrieved highest version for the provided Skill Name
--      @G_ODA_DYNAMIC_ENTITY_ID    - ODA Dynamic Entity ID: retrieved for the provided Skill & Dynamic Entity Name
-- =============================================
AS
    -- ODA API Required variables
    G_OCI_WEB_CREDENTIALS varchar2(1000);
    G_ODA_BASE_URL varchar2(4000);
    G_ODA_SKILL_ID varchar2(4000);
    G_ODA_DYNAMIC_ENTITY_ID varchar2(4000);
    
-- =============================================
-- Procedure:      SET_ODA_CONN
-- Description: Sets the Global Variables for the ODA Connection
-- Parameters:
--      @l_credential               - Used to set  @G_OCI_WEB_CREDENTIALS with the OCI connection Credentials
--      @l_api_base_url             - Used to set  @G_ODA_BASE_URL with the ODA connection Base API URL
-- Returns:                         
-- =============================================
    PROCEDURE SET_ODA_CONN(l_credential varchar2, l_api_base_url varchar2);

-- =============================================
-- Procedure:      GET_SKILL
-- Description: Connects to ODA to retrieve the Skill ID for the lastest and highers version of the Skill Name supplied
--              and sets @G_ODA_SKILL_ID with the retrieved Skill ID
-- Parameters:
--      @l_skill_name               - The ODA Skill Name 
-- Returns: @l_curr_oda_skill_id    - The ODA Skill ID                        
-- =============================================
    PROCEDURE GET_SKILL(l_skill_name in varchar2, l_curr_oda_skill_id out varchar2);

 -- =============================================
-- Procedure:      GET_DYNAMIC_ENTITY
-- Description: Connects to ODA to retrieve the Dynamic Entity ID for the Skill Name supplied
--              and sets @G_ODA_DYNAMIC_ENTITY_ID with the retrieved Dynamic Entity ID
-- Parameters:
--      @l_dynamic_entity_name               - The ODA Dynamic Entity Name 
-- Returns: @l_curr_oda_dynamic_entity_id    - The ODA Dynamic Entity ID                        
-- =============================================
    PROCEDURE GET_DYNAMIC_ENTITY(l_dynamic_entity_name in varchar2, l_curr_oda_dynamic_entity_id out varchar2);

-- =============================================
-- Procedure:      PUSH_DYNAMIC_ENTITY_DATA
-- Description: Connects to ODA, manages the Push Data Request for a single Dynamic Entity Value for the Skill & Dynamic Entity Names supplied
-- Parameters:
--      @l_push_type            - The ODA Push Data Request request type: ['add','delete','modify']
--      @l_canonicalName        - The Dynamic Entity Value in the ODA value list
--      @l_synonyms             - A varchar2 array of strings for Dynamic Entity Value Synonyms that refer to the Value in the ODA Value list 
-- Returns:                        
-- =============================================
    PROCEDURE PUSH_DYNAMIC_ENTITY_DATA(l_push_type varchar2, l_canonicalName varchar2, l_synonyms varchar2);

-- =============================================
-- Procedure:      REFRESH_PUSH_DYNAMIC_ENTITY_DATA
-- Description: Connects to ODA, manages the Push Data Request to refresh a Dynamic Entity Value list for the Skill & Dynamic Entity Names supplied
--              **This was written specifically to match the Tables to Dynamic Entities of the Hack Participants APEX to ODA app**
-- Parameters:
--      @l_dynamic_entity_name  - The ODA Push Dynamic Entity Name: ['hack_challenges','hack_teams','hack_participants','hack_skills','hack_countries'] 
-- Returns:                        
-- =============================================
    PROCEDURE REFRESH_PUSH_DYNAMIC_ENTITY_DATA(l_dynamic_entity_name in varchar2);
END;
/


CREATE OR REPLACE PACKAGE BODY "APEX_ODA" 
-- =============================================
-- Author:      Sydney Nurse@Oracle Switzerland
-- Create date: Covid-19 Pandemic Junly 2021
-- Description: Manages the ODA API Push Data Requests - developed for the Hack Participants APEX to ODA app
-- Global Parameters:
--      @G_OCI_WEB_CREDENTIALS      - OCI connection Credentials
--      @G_ODA_BASE_URL             - ODA connection Base API URL
--      @G_ODA_SKILL_ID             - ODA Skill ID: retrieved highest version for the provided Skill Name
--      @G_ODA_DYNAMIC_ENTITY_ID    - ODA Dynamic Entity ID: retrieved for the provided Skill & Dynamic Entity Name
-- =============================================
AS
    
-- =============================================
-- Procedure:      SET_ODA_CONN
-- Description: Sets the Global Variables for the ODA Connection
-- Parameters:
--      @l_credential               - Used to set  @G_OCI_WEB_CREDENTIALS with the OCI connection Credentials
--      @l_api_base_url             - Used to set  @G_ODA_BASE_URL with the ODA connection Base API URL
-- Returns:                         
-- =============================================
    PROCEDURE SET_ODA_CONN 
    (
        l_credential in varchar2,
        l_api_base_url in varchar2
    ) 
    AS
    BEGIN
        APEX_ODA.G_OCI_WEB_CREDENTIALS := l_credential;
        APEX_ODA.G_ODA_BASE_URL := l_api_base_url;
    END SET_ODA_CONN;
    
-- =============================================
-- Procedure:      GET_SKILL
-- Description: Connects to ODA to retrieve the Skill ID for the lastest and highers version of the Skill Name supplied
--              and sets @G_ODA_SKILL_ID with the retrieved Skill ID
-- Parameters:
--      @l_skill_name               - The ODA Skill Name 
-- Returns: @l_curr_oda_skill_id    - The ODA Skill ID                        
-- =============================================
    PROCEDURE GET_SKILL(l_skill_name in varchar2,
    l_curr_oda_skill_id out varchar2)
    AS
        --l_curr_oda_skill_id varchar2(2000);
        l_curr_oda_skill_version number := 0;
        l_response clob;
    BEGIN
        -- set any required headers for the request (suggested minimum required)
        apex_web_service.g_request_headers.delete();
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';

        -- response received needs to be parsed
        l_response := apex_web_service.make_rest_request(
            p_url => APEX_ODA.G_ODA_BASE_URL || 'skills?name=' || l_skill_name,
            p_http_method => 'GET',
            p_credential_static_id => APEX_ODA.G_OCI_WEB_CREDENTIALS
        );
        -- response received needs to be parsed
        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        -- Using JSON_Table to extract Skill ID and version for the latest version of the skill
        select id,version into l_curr_oda_skill_id, l_curr_oda_skill_version from (  
            select id,name,version from json_table(l_response, '$.items[*]'
            columns(
                id      varchar2(2000) path '$.id',
                name    varchar2(2000) path '$.name',
                version varchar2(2000) path '$.version'
                ) 
            ) jt
            order by version desc
        ) where rownum = 1; 

        APEX_ODA.G_ODA_SKILL_ID := l_curr_oda_skill_id;

        dbms_output.put_line('Highest skill id version is: ' || l_curr_oda_skill_id || 'version: ' || l_curr_oda_skill_version || CHR(10)); 
        dbms_output.put_line('*******' || CHR(10));

    END GET_SKILL;

 -- =============================================
-- Procedure:      GET_DYNAMIC_ENTITY
-- Description: Connects to ODA to retrieve the Dynamic Entity ID for the Skill Name supplied
--              and sets @G_ODA_DYNAMIC_ENTITY_ID with the retrieved Dynamic Entity ID
-- Parameters:
--      @l_dynamic_entity_name               - The ODA Dynamic Entity Name 
-- Returns: @l_curr_oda_dynamic_entity_id    - The ODA Dynamic Entity ID                        
-- =============================================
    PROCEDURE GET_DYNAMIC_ENTITY(l_dynamic_entity_name in varchar2,
    l_curr_oda_dynamic_entity_id out varchar2)
    AS
        --l_curr_oda_dynamic_entity_id varchar2(2000);
        l_curr_oda_dynamic_entity_name varchar2(2000);
        l_response clob;
    BEGIN
        -- set any required headers for the request (suggested minimum required)
        apex_web_service.g_request_headers.delete();
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';

        dbms_output.put_line('current skill is: ' || APEX_ODA.G_ODA_SKILL_ID || CHR(10));
        dbms_output.put_line('current url: ' || APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities'|| CHR(10));

            -- Use the Skill ID to List the Dynamic Entities of the Skill
        l_response := apex_web_service.make_rest_request(
            p_url => APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities', 
            p_http_method => 'GET',
            p_credential_static_id => APEX_ODA.G_OCI_WEB_CREDENTIALS
        );

        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        -- Get the ID for the Dynamic Entity by its name passed in as a parameter => DYNAMIC_ENTITY_NAME
        select id, name  into l_curr_oda_dynamic_entity_id, l_curr_oda_dynamic_entity_name
        from json_table(l_response, '$.items[*]'
            columns(
                id      varchar2(2000) path '$.id',
                name    varchar2(2000) path '$.name'
                ) 
            ) jt
        where upper(name) = upper(l_dynamic_entity_name ) ; 

        APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID := l_curr_oda_dynamic_entity_id;

        dbms_output.put_line('Dynamic Entity id  is: ' || l_curr_oda_dynamic_entity_id);
        dbms_output.put_line('*******' || CHR(10));

    END GET_DYNAMIC_ENTITY;

-- =============================================
-- Procedure:      PUSH_DYNAMIC_ENTITY_DATA
-- Description: Connects to ODA, manages the Push Data Request for a single Dynamic Entity Value for the Skill & Dynamic Entity Names supplied
-- Parameters:
--      @l_push_type            - The ODA Push Data Request request type: ['add','delete','modify']
--      @l_canonicalName        - The Dynamic Entity Value in the ODA value list
--      @l_synonyms             - A varchar2 array of strings for Dynamic Entity Value Synonyms that refer to the Value in the ODA Value list 
-- Returns:                        
-- =============================================
    PROCEDURE PUSH_DYNAMIC_ENTITY_DATA
    (
        l_push_type in varchar2,
        l_canonicalName in varchar2,
        l_synonyms in varchar2
    )
    AS
        l_json_body json_object_t;
        l_response clob;
        l_json_text varchar2(4000);
        l_push_request_id varchar2(4000);

        v_sql_dynamic_entity_push varchar2(4000) := 'select json_object('''
            || l_push_type || ''' value json_arrayagg(json_object('''
            || 'canonicalName' || ''' value ''' || l_canonicalName || ''', '''
            || 'synonyms' || ''' value json_array('''
            || l_synonyms || '''), '''
            || 'nativeLanguageTag' || ''' value '''
            || 'en' || ''')) returning varchar2) requestData from DUAL';

    BEGIN
        -- set any required headers for the request (suggested minimum required)
        apex_web_service.g_request_headers.delete();
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';

        -- Create Push requests
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(' CREATE PUSH REQUEST : POST' || CHR(10));
        dbms_output.put_line(APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        l_response := apex_web_service.make_rest_request(
            p_url => APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests?copy=TRUE',
            p_http_method => 'POST',
            p_credential_static_id => APEX_ODA.G_OCI_WEB_CREDENTIALS,
            p_body => to_clob(' ')
        );

        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(apex_web_service.g_status_code || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        
        --parse the response
        apex_json.parse(l_response);
        --get the Push Request ID
        l_push_request_id := apex_json.get_varchar2('id');

        dbms_output.put_line(l_push_request_id|| CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        -- PUSH DATA to PUSH REQUEST
        dbms_output.put_line('*******'|| CHR(10));
        dbms_output.put_line('PUSH DATA to REQUEST : PATCH' || CHR(10));

        -- set the dynamic entity payload from table
        execute immediate v_sql_dynamic_entity_push into l_json_text;

        --set the Data to Push to the Request
        l_json_body :=  JSON_OBJECT_T(l_json_text);

        l_response := apex_web_service.make_rest_request(
            p_url => APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests/' || l_push_request_id || '/values',
            p_http_method => 'PATCH',
            p_body => l_json_body.to_clob(),
            p_credential_static_id => APEX_ODA.G_OCI_WEB_CREDENTIALS
        );

        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(apex_web_service.g_status_code || CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        -- FINALIZE PUSH REQUEST
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line('FINALIZE PUSH REQUEST : PUT' || CHR(10));
        dbms_output.put_line(APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests/' || l_push_request_id || '/DONE'|| CHR(10));
    
        l_response := apex_web_service.make_rest_request(
            p_url => APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests/' || l_push_request_id || '/DONE',
            p_http_method => 'PUT',
            p_credential_static_id => APEX_ODA.G_OCI_WEB_CREDENTIALS,
            p_body => to_clob(' ')
        );

        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line(apex_web_service.g_status_code || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line('DONE' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
    END PUSH_DYNAMIC_ENTITY_DATA;

-- =============================================
-- Procedure:      REFRESH_PUSH_DYNAMIC_ENTITY_DATA
-- Description: Connects to ODA, manages the Push Data Request to refresh a Dynamic Entity Value list for the Skill & Dynamic Entity Names supplied
--              **This was written specifically to match the Tables to Dynamic Entities of the Hack Participants APEX to ODA app**
-- Parameters:
--      @l_dynamic_entity_name  - The ODA Push Dynamic Entity Name: ['hack_challenges','hack_teams','hack_participants','hack_skills','hack_countries'] 
-- Returns:                        
-- =============================================
    PROCEDURE REFRESH_PUSH_DYNAMIC_ENTITY_DATA
    (
        l_dynamic_entity_name in varchar2
    )
    AS
        l_json_body json_object_t;
        l_response clob;
        l_json_text varchar2(4000);
        l_push_request_id varchar2(4000);
        
        l_pre_sql_stmt varchar2(2000) :=  'select json_object( '''
            || 'add' || ''' value json_arrayagg( json_object('''
            || 'canonicalName' ;
        
        l_post_sql_stmt varchar2(4000) := 'nativeLanguageTag' || ''' value '''
            || 'en' || ''')) returning varchar2)';

        -- full data refresh from tables
        v_sql_challenges_str varchar2(4000) := l_pre_sql_stmt
            || ''' value title, '''
            || 'synonyms' || ''' value json_array(label), '''
            || l_post_sql_stmt || ' challenges from hack_content where type = '''
            || 'challenges' || '''';

        v_sql_teams_str varchar2(4000) := l_pre_sql_stmt
            || ''' value name, '''
            || 'synonyms' || ''' value json_array(project), '''
            || l_post_sql_stmt || ' teams from hack_teams';

        v_sql_participants_str varchar2(4000) := l_pre_sql_stmt
            || ''' value first_name || '''
            || ' ' || ''' || last_name, '''
            || 'synonyms' || ''' value json_array(email_address || '''
            || ':' || ''' || mobile_number), '''
            || l_post_sql_stmt || ' participants from hack_participants';

        v_sql_skills_str varchar2(4000) := l_pre_sql_stmt
            || ''' value name, '''
            || l_post_sql_stmt || ' teams from hack_skills';
        
        v_sql_countries_str varchar2(4000) := l_pre_sql_stmt
        || ''' value  nvl(region,'''
        || 'Other' || '''),''' 
        || 'synonyms' || ''' value json_array(LISTAGG(name, '''
        || ':' || ''') WITHIN GROUP (ORDER BY name asc)),'''
        || l_post_sql_stmt || ' regions from hack_countries GROUP BY nvl(region,'''
        || 'Other' || ''') ';

    BEGIN
        -- set any required headers for the request (suggested minimum required)
        apex_web_service.g_request_headers.delete();
        apex_web_service.g_request_headers(1).name := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';

        -- Create Push requests
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(' CREATE PUSH REQUEST : POST' || CHR(10));
        dbms_output.put_line(APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests?copy=FALSE' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        l_response := apex_web_service.make_rest_request(
            p_url => APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests?copy=FALSE',
            p_http_method => 'POST',
            p_credential_static_id => APEX_ODA.G_OCI_WEB_CREDENTIALS,
            p_body => to_clob(' ')
        );

        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(apex_web_service.g_status_code || CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        --parse the response
        apex_json.parse(l_response);
        --get the Push Request ID
        l_push_request_id := apex_json.get_varchar2('id');

        dbms_output.put_line(l_push_request_id|| CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        -- PUSH DATA to PUSH REQUEST
        dbms_output.put_line('*******'|| CHR(10));
        dbms_output.put_line('PUSH DATA to REQUEST : PATCH' || CHR(10));

        -- set the dynamic entity payload from table
        case l_dynamic_entity_name
            when 'hack_challenges'
                then execute immediate v_sql_challenges_str into l_json_text;
            when 'hack_teams'
                then execute immediate v_sql_teams_str into l_json_text;
            when 'hack_participants'
                then execute immediate v_sql_participants_str into l_json_text;
            when 'hack_skills'
                then execute immediate v_sql_skills_str into l_json_text;
            when 'hack_countries'
                then execute immediate v_sql_countries_str into l_json_text;
        end case;

        --set the Data to Push to the Request
        l_json_body :=  JSON_OBJECT_T(l_json_text);
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(l_json_text || CHR(10));

        l_response := apex_web_service.make_rest_request(
            p_url => APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests/' || l_push_request_id || '/values',
            p_http_method => 'PATCH',
            p_body => l_json_body.to_clob(),
            p_credential_static_id => APEX_ODA.G_OCI_WEB_CREDENTIALS
        );

        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(apex_web_service.g_status_code || CHR(10));
        dbms_output.put_line('*******' || CHR(10));

        -- FINALIZE PUSH REQUEST
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line('FINALIZE PUSH REQUEST : PUT' || CHR(10));
        dbms_output.put_line(APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests/' || l_push_request_id || '/DONE'|| CHR(10));
    
        l_response := apex_web_service.make_rest_request(
            p_url => APEX_ODA.G_ODA_BASE_URL || 'bots/' || APEX_ODA.G_ODA_SKILL_ID ||'/dynamicEntities/' || APEX_ODA.G_ODA_DYNAMIC_ENTITY_ID || '/pushRequests/' || l_push_request_id || '/DONE',
            p_http_method => 'PUT',
            p_credential_static_id => APEX_ODA.G_OCI_WEB_CREDENTIALS,
            p_body => to_clob(' ')
        );

        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line(l_response || CHR(10));
        dbms_output.put_line(apex_web_service.g_status_code || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
        dbms_output.put_line('DONE' || CHR(10));
        dbms_output.put_line('*******' || CHR(10));
    END REFRESH_PUSH_DYNAMIC_ENTITY_DATA;
END;
/

CREATE OR REPLACE PACKAGE "HACK_LEADS_MENTORS_API" 
is 
  
    /* example: 
        declare 
            l_lead_mentor_id                number; 
            l_mentor_id                     number; 
        begin 
        hack_leads_mentors_api.get_row ( 
            p_id                            => 1, 
            p_lead_mentor_id                => l_lead_mentor_id, 
            p_mentor_id                     => l_mentor_id 
            ); 
        end; 
    */ 
 
    procedure get_row ( 
        p_id                           in number, 
        P_lead_mentor_id               out number, 
        P_mentor_id                    out number 
    ); 
  
    /* example: 
        begin 
        hack_leads_mentors_api.insert_row ( 
            p_id                          => null, 
            p_lead_mentor_id              => null, 
            p_mentor_id                   => null 
            ); 
        end; 
    */ 
 
    procedure insert_row  ( 
        p_id                           in number default null, 
        p_lead_mentor_id               in number default null, 
        p_mentor_id                    in number default null 
    ); 
    procedure update_row  ( 
        p_id                           in number default null, 
        p_lead_mentor_id               in number default null, 
        p_mentor_id                    in number default null 
    ); 
    procedure delete_row ( 
        p_id                           in number 
    ); 
end hack_leads_mentors_api; 
/


CREATE OR REPLACE PACKAGE BODY "HACK_LEADS_MENTORS_API" 
is 
  
    procedure get_row ( 
        p_id                           in number, 
        P_lead_mentor_id               out number, 
        P_mentor_id                    out number 
    ) 
    is 
    begin 
        for c1 in (select * from hack_leads_mentors where id = p_id) loop 
            p_lead_mentor_id := c1.lead_mentor_id; 
            p_mentor_id := c1.mentor_id; 
        end loop; 
    end get_row; 
 
  
    procedure insert_row  ( 
        p_id                           in number default null, 
        p_lead_mentor_id               in number default null, 
        p_mentor_id                    in number default null 
    ) 
    is 
    begin 
        insert into hack_leads_mentors ( 
            id, 
            lead_mentor_id, 
            mentor_id 
        ) values ( 
            p_id, 
            p_lead_mentor_id, 
            p_mentor_id 
        ); 
    end insert_row; 
 
    procedure update_row  ( 
        p_id                           in number default null, 
        p_lead_mentor_id               in number default null, 
        p_mentor_id                    in number default null 
    ) 
    is 
    begin 
        update  hack_leads_mentors set  
            id = p_id, 
            lead_mentor_id = p_lead_mentor_id, 
            mentor_id = p_mentor_id 
        where id = p_id; 
    end update_row; 
 
    procedure delete_row ( 
        p_id                           in number 
    ) 
    is 
    begin 
        delete from hack_leads_mentors where id = p_id; 
    end delete_row; 
 
end hack_leads_mentors_api; 
/

CREATE OR REPLACE PACKAGE "HACK_PARTICIPANTS_API" 
is 
  
    /* example: 
        declare 
            l_first_name                    varchar2(255); 
            l_last_name                     varchar2(255); 
            l_email_address                 varchar2(100); 
            l_mobile_number                 varchar2(40); 
            l_country                       number; 
            l_mentor_flag                   varchar2(1); 
            l_lead_mentor_flag              varchar2(1); 
        begin 
        hack_participants_api.get_row ( 
            p_id                            => 1, 
            p_first_name                    => l_first_name, 
            p_last_name                     => l_last_name, 
            p_email_address                 => l_email_address, 
            p_mobile_number                 => l_mobile_number, 
            p_country                       => l_country, 
            p_mentor_flag                   => l_mentor_flag, 
            p_lead_mentor_flag              => l_lead_mentor_flag 
            ); 
        end; 
    */ 
 
    procedure get_row ( 
        p_id                           in number, 
        P_first_name                   out varchar2, 
        P_last_name                    out varchar2, 
        P_email_address                out varchar2, 
        P_mobile_number                out varchar2, 
        P_country                      out number, 
        P_mentor_flag                  out varchar2, 
        P_lead_mentor_flag             out varchar2 
    ); 
  
    /* example: 
        begin 
        hack_participants_api.insert_row ( 
            p_id                          => null, 
            p_first_name                  => null, 
            p_last_name                   => null, 
            p_email_address               => null, 
            p_mobile_number               => null, 
            p_country                     => null, 
            p_mentor_flag                 => null, 
            p_lead_mentor_flag            => null 
            ); 
        end; 
    */ 
 
    procedure insert_row  ( 
        p_id                           in number default null, 
        p_first_name                   in varchar2 default null, 
        p_last_name                    in varchar2 default null, 
        p_email_address                in varchar2 default null, 
        p_mobile_number                in varchar2 default null, 
        p_country                      in number default null, 
        p_mentor_flag                  in varchar2 default null, 
        p_lead_mentor_flag             in varchar2 default null 
    ); 
    procedure update_row  ( 
        p_id                           in number default null, 
        p_first_name                   in varchar2 default null, 
        p_last_name                    in varchar2 default null, 
        p_email_address                in varchar2 default null, 
        p_mobile_number                in varchar2 default null, 
        p_country                      in number default null, 
        p_mentor_flag                  in varchar2 default null, 
        p_lead_mentor_flag             in varchar2 default null 
    ); 
    procedure delete_row ( 
        p_id                           in number 
    ); 
 
    procedure rest_add_participant  (  
        p_first_name                   in varchar2 default null, 
        p_last_name                    in varchar2 default null, 
        p_email_address                in varchar2 default null, 
        p_mobile_number                in varchar2 default null, 
        p_country                      in varchar2 default null, 
        p_mentor_flag                  in varchar2 default null, 
        p_lead_mentor_flag             in varchar2 default null,
        p_challenge                    in varchar2 default null
        --,
        --p_oda_base_url                 in varchar2 default null 
    );

end hack_participants_api; 
/


CREATE OR REPLACE PACKAGE BODY "HACK_PARTICIPANTS_API" 
is 
  
    procedure get_row ( 
        p_id                           in number, 
        P_first_name                   out varchar2, 
        P_last_name                    out varchar2, 
        P_email_address                out varchar2, 
        P_mobile_number                out varchar2, 
        P_country                      out number, 
        P_mentor_flag                  out varchar2, 
        P_lead_mentor_flag             out varchar2 
    ) 
    is 
    begin 
        for c1 in (select * from hack_participants where id = p_id) loop 
            p_first_name := c1.first_name; 
            p_last_name := c1.last_name; 
            p_email_address := c1.email_address; 
            p_mobile_number := c1.mobile_number; 
            p_country := c1.country; 
            p_mentor_flag := c1.mentor_flag; 
            p_lead_mentor_flag := c1.lead_mentor_flag; 
        end loop; 
    end get_row; 
 
  
    procedure insert_row  ( 
        p_id                           in number default null, 
        p_first_name                   in varchar2 default null, 
        p_last_name                    in varchar2 default null, 
        p_email_address                in varchar2 default null, 
        p_mobile_number                in varchar2 default null, 
        p_country                      in number default null, 
        p_mentor_flag                  in varchar2 default null, 
        p_lead_mentor_flag             in varchar2 default null 
    ) 
    is 
    begin 
        insert into hack_participants ( 
            id, 
            first_name, 
            last_name, 
            email_address, 
            mobile_number, 
            country, 
            mentor_flag, 
            lead_mentor_flag 
        ) values ( 
            p_id, 
            p_first_name, 
            p_last_name, 
            p_email_address, 
            p_mobile_number, 
            p_country, 
            p_mentor_flag, 
            p_lead_mentor_flag 
        ); 
    end insert_row; 
 
    procedure update_row  ( 
        p_id                           in number default null, 
        p_first_name                   in varchar2 default null, 
        p_last_name                    in varchar2 default null, 
        p_email_address                in varchar2 default null, 
        p_mobile_number                in varchar2 default null, 
        p_country                      in number default null, 
        p_mentor_flag                  in varchar2 default null, 
        p_lead_mentor_flag             in varchar2 default null 
    ) 
    is 
    begin 
        update  hack_participants set  
            id = p_id, 
            first_name = p_first_name, 
            last_name = p_last_name, 
            email_address = p_email_address, 
            mobile_number = p_mobile_number, 
            country = p_country, 
            mentor_flag = p_mentor_flag, 
            lead_mentor_flag = p_lead_mentor_flag 
        where id = p_id; 
    end update_row; 
 
    procedure delete_row ( 
        p_id                           in number 
    ) 
    is 
    begin 
        delete from hack_participants where id = p_id; 
    end delete_row; 

    procedure rest_add_participant  (  
        p_first_name                   in varchar2 default null, 
        p_last_name                    in varchar2 default null, 
        p_email_address                in varchar2 default null, 
        p_mobile_number                in varchar2 default null, 
        p_country                      in varchar2 default null, 
        p_mentor_flag                  in varchar2 default null, 
        p_lead_mentor_flag             in varchar2 default null,
        p_challenge                    in varchar2 default null
        --,
        --p_oda_base_url                 in varchar2 default null 
    )
    is
        l_app_id                         number;
        l_country                       number; 
        l_id                            number;
        l_challenge_id                  number;
        --G_ODA_BASE_URL varchar2(4000) := p_oda_base_url;
        --G_OCI_WEB_CREDENTIALS varchar2(1000) := 'OCIODA';
        l_skill_id varchar2(4000);
        l_dynamic_entity_id varchar2(4000);
    begin

        select c.id into l_country from hack_countries c where upper(c.name) like upper('%'|| p_country ||'%');

        insert into hack_participants 
            (
            first_name, 
            last_name, 
            email_address, 
            mobile_number, 
            country, 
            mentor_flag, 
            lead_mentor_flag
            )
            values
            (  
            p_first_name, 
            p_last_name, 
            p_email_address, 
            p_mobile_number,
            l_country, 
            upper(p_mentor_flag), 
            upper(p_lead_mentor_flag)
            )
            returning id into l_id; 
        
        select c.id into l_challenge_id from hack_content c where upper(c.title) like upper('%' || p_challenge ||'%');

        insert into hack_participant_interests
            (
                participant_id,
                challenge
            )
            values
            (
                l_id,
                l_challenge_id
            );

        select application_id into l_app_id from apex_applications where application_name ='PART01';

        apex_session.create_session(
            p_app_id => l_app_id,
            p_page_id => 1,
            p_username => 'hack'
        );

        APEX_ODA.SET_ODA_CONN(V('G_OCI_WEB_CREDENTIALS'), V('G_ODA_BASE_URL'));
        APEX_ODA.GET_SKILL(V('G_ODA_SKILL'), l_skill_id);
        APEX_ODA.GET_DYNAMIC_ENTITY('hack_participants', l_dynamic_entity_id);
        APEX_ODA.PUSH_DYNAMIC_ENTITY_DATA(
            'add',
            p_first_name || ' ' || p_last_name,
            p_email_address || ':' || p_mobile_number );
        
        apex_session.delete_session;

    end rest_add_participant;
 
end hack_participants_api; 
/

CREATE OR REPLACE PACKAGE "HACK_TEAMS_API" 
is 
  
    /* example: 
        declare 
            l_name                          varchar2(255); 
            l_challenge                     number; 
        begin 
        hack_teams_api.get_row ( 
            p_id                            => 1, 
            p_name                          => l_name, 
            p_challenge                     => l_challenge 
            ); 
        end; 
    */ 
 
    procedure get_row ( 
        p_id                           in number, 
        P_name                         out varchar2, 
        P_challenge                    out number 
    ); 
  
    /* example: 
        begin 
        hack_teams_api.insert_row ( 
            p_id                          => null, 
            p_name                        => null, 
            p_challenge                   => null 
            ); 
        end; 
    */ 
 
    procedure insert_row  ( 
        p_id                           in number default null, 
        p_name                         in varchar2 default null, 
        p_challenge                    in number default null 
    ); 
    procedure update_row  ( 
        p_id                           in number default null, 
        p_name                         in varchar2 default null, 
        p_challenge                    in number default null 
    ); 
    procedure delete_row ( 
        p_id                           in number 
    ); 

    procedure rest_add_team  (
        p_name                         in varchar2 default null,
        p_project                      in varchar2 default null, 
        p_challenge                    in varchar2 default null, 
        p_description                  in varchar2 default null
    ); 
     
end hack_teams_api; 
/


CREATE OR REPLACE PACKAGE BODY "HACK_TEAMS_API" 
is 
  
    procedure get_row ( 
        p_id                           in number, 
        P_name                         out varchar2, 
        P_challenge                    out number 
    ) 
    is 
    begin 
        for c1 in (select * from hack_teams where id = p_id) loop 
            p_name := c1.name; 
            p_challenge := c1.challenge; 
        end loop; 
    end get_row; 
 
  
    procedure insert_row  ( 
        p_id                           in number default null, 
        p_name                         in varchar2 default null, 
        p_challenge                    in number default null 
    ) 
    is 
    begin 
        insert into hack_teams ( 
            id, 
            name, 
            challenge 
        ) values ( 
            p_id, 
            p_name, 
            p_challenge 
        ); 
    end insert_row; 
 
    procedure update_row  ( 
        p_id                           in number default null, 
        p_name                         in varchar2 default null, 
        p_challenge                    in number default null 
    ) 
    is 
    begin 
        update  hack_teams set  
            id = p_id, 
            name = p_name, 
            challenge = p_challenge 
        where id = p_id; 
    end update_row; 
 
    procedure delete_row ( 
        p_id                           in number 
    ) 
    is 
    begin 
        delete from hack_teams where id = p_id; 
    end delete_row; 
 
    procedure rest_add_team  ( 
        p_name                         in varchar2 default null,
        p_project                      in varchar2 default null, 
        p_challenge                    in varchar2 default null, 
        p_description                  in varchar2 default null  
    ) 
    is
        l_app_id                        number;
        l_challenge_id                  number;
        --G_ODA_BASE_URL varchar2(4000) := p_oda_base_url;
        --G_OCI_WEB_CREDENTIALS varchar2(1000) := 'OCIODA';
        l_skill_id varchar2(4000);
        l_dynamic_entity_id varchar2(4000);
    begin

        select c.id into l_challenge_id from hack_content c where upper(c.title) like upper('%' || p_challenge ||'%');

        insert into hack_teams ( 
            name,
            project, 
            challenge,
            description 
        ) values ( 
            p_name,
            p_project, 
            l_challenge_id,
            p_description 
        );

        select application_id into l_app_id from apex_applications where application_name ='PART01';

        apex_session.create_session(
            p_app_id => l_app_id,
            p_page_id => 1,
            p_username => 'hack'
        );

        APEX_ODA.SET_ODA_CONN(V('G_OCI_WEB_CREDENTIALS'), V('G_ODA_BASE_URL'));
        APEX_ODA.GET_SKILL(V('G_ODA_SKILL'), l_skill_id);
        APEX_ODA.GET_DYNAMIC_ENTITY('hack_teams', l_dynamic_entity_id);
        APEX_ODA.PUSH_DYNAMIC_ENTITY_DATA(
            'add',
            p_name,
            p_project);
        
        apex_session.delete_session;
 
    end rest_add_team; 

end hack_teams_api; 
/

CREATE OR REPLACE PACKAGE "HACK_TEAM_PARTICIPANTS_API" 
is 
  
    /* example: 
        declare 
            l_team_id                       number; 
            l_participant_id                number; 
        begin 
        hack_team_participants_api.get_row ( 
            p_id                            => 1, 
            p_team_id                       => l_team_id, 
            p_participant_id                => l_participant_id 
            ); 
        end; 
    */ 
 
    procedure get_row ( 
        p_id                           in number, 
        P_team_id                      out number, 
        P_participant_id               out number 
    ); 
  
    /* example: 
        begin 
        hack_team_participants_api.insert_row ( 
            p_id                          => null, 
            p_team_id                     => null, 
            p_participant_id              => null 
            ); 
        end; 
    */ 
 
    procedure insert_row  ( 
        p_id                           in number default null, 
        p_team_id                      in number default null, 
        p_participant_id               in number default null 
    ); 
    procedure update_row  ( 
        p_id                           in number default null, 
        p_team_id                      in number default null, 
        p_participant_id               in number default null 
    ); 
    procedure delete_row ( 
        p_id                           in number 
    ); 

    procedure rest_add_team_member  (
        p_name                         in varchar2 default null,
        p_member_first_name            in varchar2 default null,
        p_member_last_name             in varchar2 default null
    ); 

end hack_team_participants_api; 
/


CREATE OR REPLACE PACKAGE BODY "HACK_TEAM_PARTICIPANTS_API" 
is 
  
    procedure get_row ( 
        p_id                           in number, 
        P_team_id                      out number, 
        P_participant_id               out number 
    ) 
    is 
    begin 
        for c1 in (select * from hack_team_participants where id = p_id) loop 
            p_team_id := c1.team_id; 
            p_participant_id := c1.participant_id; 
        end loop; 
    end get_row; 
 
  
    procedure insert_row  ( 
        p_id                           in number default null, 
        p_team_id                      in number default null, 
        p_participant_id               in number default null 
    ) 
    is 
    begin 
        insert into hack_team_participants ( 
            id, 
            team_id, 
            participant_id 
        ) values ( 
            p_id, 
            p_team_id, 
            p_participant_id 
        ); 
    end insert_row; 
 
    procedure update_row  ( 
        p_id                           in number default null, 
        p_team_id                      in number default null, 
        p_participant_id               in number default null 
    ) 
    is 
    begin 
        update  hack_team_participants set  
            id = p_id, 
            team_id = p_team_id, 
            participant_id = p_participant_id 
        where id = p_id; 
    end update_row; 
 
    procedure delete_row ( 
        p_id                           in number 
    ) 
    is 
    begin 
        delete from hack_team_participants where id = p_id; 
    end delete_row; 
 
    procedure rest_add_team_member  (
        p_name                         in varchar2 default null,
        p_member_first_name            in varchar2 default null,
        p_member_last_name             in varchar2 default null
    )
    is 
        p_team_id                      number default null; 
        p_participant_id               number default null;
    begin
    
        select p.id into p_participant_id from hack_participants p
            where upper(p.first_name) = upper(p_member_first_name)
                and upper(p.last_name) = upper(p_member_last_name);
        
        select t.id into p_team_id from hack_teams t
            where upper(t.name) = upper(p_name);

        insert into hack_team_participants ( 
            team_id, 
            participant_id 
        ) values ( 
            p_team_id, 
            p_participant_id 
        );
    end rest_add_team_member; 

end hack_team_participants_api; 
/

