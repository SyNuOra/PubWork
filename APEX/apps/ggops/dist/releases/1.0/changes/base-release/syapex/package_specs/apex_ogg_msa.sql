-- liquibase formatted sql
-- changeset SYAPEX:1771865126536 stripComments:false  logicalFilePath:base-release/syapex/package_specs/apex_ogg_msa.sql
-- sqlcl_snapshot src/database/syapex/package_specs/apex_ogg_msa.sql:null:1720431ca7fade7065ce410015defc206d46500e:create

create or replace package syapex.apex_ogg_msa -- =============================================
-- Author:      Sydney Nurse@Oracle Switzerland
-- Create date: Covid-19 Pandemic October 2021
-- Description: Build to support the migration of Deployments between GoldenGate MSA Deployments
-- Global Parameters:
--      @      - None
--      
-- =============================================
 as
-- Package Required Variables
-- Package Static Referenced Variables
    s_servmgr varchar2(100) := '/services/v2';
    s_adminsrvr_uri varchar2(100) := '/adminsrvr/v2';
    s_distsrvr_uri varchar2(100) := '/distsrvr/v2';
    s_recvsrvr_uri varchar2(100) := '/recvsrvr/v2';
-- =============================================
-- Package Records Definitions
-- =============================================
    type deployment_type is record (
            deployment_id       ggops_deployments.deployment_id%type,
            deployment_name     ggops_deployments.deployment_name%type,
            deployment_status   nvarchar2(400),
            deployment_enabled  nvarchar2(400),
            deployment_ogghome  nvarchar2(400),
            deployment_etchome  nvarchar2(400),
            deployment_confhome nvarchar2(400)
    );
    type deployment_list is
        table of deployment_type;
    type process_type is record (
            process_id    ggops_processes.process_id%type,
            process_name  ggops_processes.process_name%type,
            process_type  ggops_processes.process_type%type,
            process_trail ggops_processes.process_trail%type
    );
    type process_list is
        table of process_type;
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
        l_n_flow_id     in number default null,
        l_vc_credential in varchar2 default null,
        l_vc_user       in varchar2 default null,
        l_vc_password   in varchar2 default null
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
    procedure update_credential (
        l_vc_credential in varchar2 default null,
        l_vc_user       in varchar2 default null,
        l_vc_password   in varchar2 default null
    );
-- =============================================
-- Procedure:      DELETE_CREDENTIAL
-- Description: Deletes the credential details an APEX Web Credential used by a GoldenGate MSA Connection
-- Parameters:
--      @l_n_flow_id             - ID of the current Flow
--      @l_vc_credential          - Name of the connection Credentials
-- Returns:                         
-- =============================================
    procedure delete_credential (
        l_n_flow_id     in number default null,
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
    procedure rest_utl (
        l_vc_credential in varchar2 default null,
        l_vc_url        in varchar2 default null,
        l_vc_method     in varchar2 default null,
        l_vc_request    in varchar2 default null,
        l_response      out clob
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
    procedure deployments (
        l_vc_host       in varchar2 default null,
        l_vc_deployment in varchar2 default null,
        l_vc_method     in varchar2 default null
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
    procedure replication (
        l_vc_host         in varchar2 default null,
        l_vc_deployment   in varchar2 default null,
        l_vc_method       in varchar2 default null,
        l_vc_service      in varchar2 default null,
        l_vc_process_type in varchar2 default null,
        l_vc_process      in varchar2 default null
    );
-- =============================================
-- Procedure:      MIGRATE
-- Description: Migrate GoldenGate MSA Deployment Process from one Deployment to Compatible Deployment [ADMIN,DIST,RCVR]
-- Parameters:
--      @l_vc_process_id         - The GoldenGare MSA process ID to be migrated
--      @l_vc_service            - The GoldenGare MSA service [adminsrvr,distsrvr,recvsrvr]
-- Returns:                        
-- =============================================
    procedure migrate (
        l_n_process_id in number default null,
        l_vc_service   in varchar2
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
    procedure trandata (
        l_vc_host          in varchar2 default null,
        l_vc_deployment    in varchar2 default null,
        l_vc_credential_id number default null,
        l_vc_tablespec     in varchar2 default null,
        l_vc_method        in varchar2 default 'POST',
        l_curr_trandata    out varchar2
    );

end;
/

