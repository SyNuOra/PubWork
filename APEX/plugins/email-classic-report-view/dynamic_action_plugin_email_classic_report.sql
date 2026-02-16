prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.13'
,p_default_workspace_id=>7462517214675520
,p_default_application_id=>129
,p_default_id_offset=>0
,p_default_owner=>'REAPEX'
);
end;
/
 
prompt APPLICATION 129 - QSQL_Demo_01
--
-- Application Export:
--   Application:     129
--   Name:            QSQL_Demo_01
--   Date and Time:   11:51 Monday February 16, 2026
--   Exported By:     SYDNEY.NURSE
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 57490492753325191
--   Manifest End
--   Version:         24.2.13
--   Instance ID:     7462324451952942
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/email_classic_report
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(57490492753325191)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'SYNUORA.EMAIL_CLASSIC_REPORT'
,p_display_name=>'Email Classic Report'
,p_category=>'EXECUTE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function f_ajax (',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_plugin         in apex_plugin.t_plugin',
') return apex_plugin.t_dynamic_action_ajax_result is',
'    p_region_static_id  constant P_DYNAMIC_ACTION.ATTRIBUTE_01%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_01, false);',
'    p_from              constant P_DYNAMIC_ACTION.ATTRIBUTE_02%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_02, false);',
'    p_to                constant P_DYNAMIC_ACTION.ATTRIBUTE_03%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_03, false);',
'    p_cc                constant P_DYNAMIC_ACTION.ATTRIBUTE_04%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_04, false);',
'    p_bcc               constant P_DYNAMIC_ACTION.ATTRIBUTE_05%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_05, false);',
'    p_replyto           constant P_DYNAMIC_ACTION.ATTRIBUTE_06%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_06, false);',
'    p_subj              constant P_DYNAMIC_ACTION.ATTRIBUTE_07%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_07, false);',
'    p_body              constant P_DYNAMIC_ACTION.ATTRIBUTE_08%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_08, false);',
'    p_body_html         constant P_DYNAMIC_ACTION.ATTRIBUTE_09%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_09, false);',
'    p_format            constant P_DYNAMIC_ACTION.ATTRIBUTE_10%type := P_DYNAMIC_ACTION.ATTRIBUTE_10;',
'    p_filename          constant P_DYNAMIC_ACTION.ATTRIBUTE_11%type := apex_plugin_util.replace_substitutions(P_DYNAMIC_ACTION.ATTRIBUTE_11, false);',
'    l_export    apex_data_export.t_export;',
'    l_format    apex_data_export.t_format;',
'    l_region_id number;',
'    l_email_id  number;',
'    l_result               apex_plugin.t_dynamic_action_ajax_result;',
'BEGIN',
'',
'    l_format := CASE p_format',
'        WHEN ''CSV'' THEN apex_data_export.c_format_csv',
'        WHEN ''HTML'' THEN apex_data_export.c_format_html',
'        WHEN ''PDF'' THEN apex_data_export.c_format_pdf',
'        WHEN ''XLSX'' THEN apex_data_export.c_format_xlsx',
'        WHEN ''XML'' THEN apex_data_export.c_format_xml',
'        WHEN ''PXML'' THEN apex_data_export.c_format_pxml',
'        WHEN ''JSON'' THEN apex_data_export.c_format_json',
'        WHEN ''PJSON'' THEN apex_data_export.c_format_pjson',
'        ELSE apex_data_export.c_format_xlsx -- default/fallback',
'    END;',
'',
'    SELECT region_id into l_region_id',
'    FROM apex_application_page_regions',
'    WHERE application_id = :APP_ID',
'      and page_id = :APP_PAGE_ID',
'      and static_id = p_region_static_id;',
'',
'    l_export := apex_region.export_data (',
'         p_format       => l_format,',
'         p_page_id      => :APP_PAGE_ID,',
'         p_region_id    => l_region_id );',
'',
'    l_email_id := apex_mail.send(',
'        p_to        => p_to,',
'        p_from      => p_from,',
'        p_subj      => p_subj,',
'        p_body      => p_body,',
'        p_body_html => p_body_html,',
'        p_cc        => p_cc,',
'        p_bcc       => p_bcc,',
'        p_replyto   => p_replyto',
'    );',
'',
'    apex_mail.add_attachment(',
'        p_mail_id       => l_email_id,',
'        p_attachment    => l_export.content_blob,',
'        p_filename      => nvl(p_filename,l_export.file_name),',
'        p_mime_type     => l_export.mime_type',
'    );',
'',
'    apex_mail.push_queue;',
'    return l_result;',
'END;    ',
'',
'',
'function f_render (',
'    p_dynamic_action   in apex_plugin.t_dynamic_action,',
'    p_plugin           in apex_plugin.t_plugin',
') return apex_plugin.t_dynamic_action_render_result as',
'    l_result         apex_plugin.t_dynamic_action_render_result;',
'    c_cache_id     constant varchar2(32767) := to_char(p_dynamic_action.id);',
'begin',
'',
'    l_result.ajax_identifier    := apex_plugin.get_ajax_identifier;',
'    l_result.attribute_01       := c_cache_id;',
'    l_result.javascript_function    := ''',
'    function () {  ',
'        // AJAX call',
'        apex.server.plugin(this.action.ajaxIdentifier, {',
'        }, {',
'            dataType: '' || ''''''text'''''' || '', ',
'            success: function(pData) {',
'                // log successful call to send email',
'                console.log('' || ''''''Email Submitted'''''' || '', pData);',
'            },',
'            // ERROR function',
'            error: function (jqXHR, textStatus, errorThrown) {',
'                // log error call to send email',
'                console.error('' || ''''''Error sending email:'''''' || '', textStatus, errorThrown);',
'            }',
'        });',
'            ',
'    ',
'    }'';',
'',
'    return l_result;',
'end;'))
,p_api_version=>1
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_standard_attributes=>'BUTTON'
,p_substitute_attributes=>false
,p_version_scn=>46309446887376
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'An APEX Dynamic Action Plugin that will email a Classic Report view.',
'',
'It adds the current report view as an attachment and sends an email to the recipients provided in the parameters.'))
,p_version_identifier=>'1.0.0'
,p_about_url=>'https://github.com/SyNuOra/PubWork.git'
,p_updated_on=>wwv_flow_imp.dz('20260216114318Z')
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(57499643950433710)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_title=>'Report'
,p_display_sequence=>10
,p_created_on=>wwv_flow_imp.dz('20260213120820Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120820Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(57499936927433711)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_title=>'Email Settings'
,p_display_sequence=>20
,p_created_on=>wwv_flow_imp.dz('20260213120820Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120820Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57490937530337871)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Region Static ID'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499643950433710)
,p_created_on=>wwv_flow_imp.dz('20260213115222Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120937Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57491300981347633)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'From'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499936927433711)
,p_created_on=>wwv_flow_imp.dz('20260213115359Z')
,p_updated_on=>wwv_flow_imp.dz('20260213121004Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57491653601348209)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'To'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499936927433711)
,p_created_on=>wwv_flow_imp.dz('20260213115405Z')
,p_updated_on=>wwv_flow_imp.dz('20260213121011Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57491934743350209)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'CC'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499936927433711)
,p_created_on=>wwv_flow_imp.dz('20260213115425Z')
,p_updated_on=>wwv_flow_imp.dz('20260213121020Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57492225456350750)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'BCC'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499936927433711)
,p_created_on=>wwv_flow_imp.dz('20260213115431Z')
,p_updated_on=>wwv_flow_imp.dz('20260213121028Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57492498047353459)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Reply To'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499936927433711)
,p_created_on=>wwv_flow_imp.dz('20260213115458Z')
,p_updated_on=>wwv_flow_imp.dz('20260213121037Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57492835527356832)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Subject'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499936927433711)
,p_created_on=>wwv_flow_imp.dz('20260213115531Z')
,p_updated_on=>wwv_flow_imp.dz('20260213121052Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57493131637358410)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Body Plain Text'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499936927433711)
,p_created_on=>wwv_flow_imp.dz('20260213115547Z')
,p_updated_on=>wwv_flow_imp.dz('20260213121100Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57493413082361544)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Body HTML'
,p_attribute_type=>'HTML'
,p_is_required=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(57499936927433711)
,p_created_on=>wwv_flow_imp.dz('20260213115619Z')
,p_updated_on=>wwv_flow_imp.dz('20260213121107Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57493719709375304)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Format'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'XLSX'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_created_on=>wwv_flow_imp.dz('20260213115836Z')
,p_updated_on=>wwv_flow_imp.dz('20260216113743Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(57494022173382336)
,p_plugin_attribute_id=>wwv_flow_imp.id(57493719709375304)
,p_display_sequence=>10
,p_display_value=>'CSV'
,p_return_value=>'CSV'
,p_created_on=>wwv_flow_imp.dz('20260213115946Z')
,p_updated_on=>wwv_flow_imp.dz('20260213115946Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(57494388094383924)
,p_plugin_attribute_id=>wwv_flow_imp.id(57493719709375304)
,p_display_sequence=>20
,p_display_value=>'HTML'
,p_return_value=>'HTML'
,p_created_on=>wwv_flow_imp.dz('20260213120002Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120222Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(57494781880385223)
,p_plugin_attribute_id=>wwv_flow_imp.id(57493719709375304)
,p_display_sequence=>30
,p_display_value=>'PDF'
,p_return_value=>'PDF'
,p_created_on=>wwv_flow_imp.dz('20260213120015Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120232Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(57495232593386546)
,p_plugin_attribute_id=>wwv_flow_imp.id(57493719709375304)
,p_display_sequence=>40
,p_display_value=>'XLSX'
,p_return_value=>'XLSX'
,p_created_on=>wwv_flow_imp.dz('20260213120029Z')
,p_updated_on=>wwv_flow_imp.dz('20260213135159Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(57495634964390150)
,p_plugin_attribute_id=>wwv_flow_imp.id(57493719709375304)
,p_display_sequence=>50
,p_display_value=>'XML'
,p_return_value=>'XML'
,p_created_on=>wwv_flow_imp.dz('20260213120105Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120242Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(57496055909392781)
,p_plugin_attribute_id=>wwv_flow_imp.id(57493719709375304)
,p_display_sequence=>60
,p_display_value=>'PXML'
,p_return_value=>'PXML'
,p_created_on=>wwv_flow_imp.dz('20260213120131Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120254Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(57496463248394412)
,p_plugin_attribute_id=>wwv_flow_imp.id(57493719709375304)
,p_display_sequence=>70
,p_display_value=>'JSON'
,p_return_value=>'JSON'
,p_created_on=>wwv_flow_imp.dz('20260213120147Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120147Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(57496786447396437)
,p_plugin_attribute_id=>wwv_flow_imp.id(57493719709375304)
,p_display_sequence=>80
,p_display_value=>'PJSON'
,p_return_value=>'PJSON'
,p_created_on=>wwv_flow_imp.dz('20260213120207Z')
,p_updated_on=>wwv_flow_imp.dz('20260213120207Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(57504149827555135)
,p_plugin_id=>wwv_flow_imp.id(57490492753325191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Filename'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_created_on=>wwv_flow_imp.dz('20260213122834Z')
,p_updated_on=>wwv_flow_imp.dz('20260213122834Z')
,p_created_by=>'SYDNEY.NURSE'
,p_updated_by=>'SYDNEY.NURSE'
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
