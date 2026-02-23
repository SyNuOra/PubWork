-- liquibase formatted sql
-- changeset SYAPEX:1771865128110 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_configuration_files_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_configuration_files_biu.sql:null:ec2d6bd0a9f6be7778d30c7d7ad7c700c3f6676d:create

create or replace editionable trigger syapex.ggops_configuration_files_biu before
    insert or update on syapex.ggops_configuration_files
    for each row
begin
    if inserting then
        :new.created := localtimestamp;
        :new.created_by := coalesce(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        );
    end if;

    :new.updated := localtimestamp;
    :new.updated_by := coalesce(
        sys_context('APEX$SESSION', 'APP_USER'),
        user
    );
end ggops_configuration_files_biu;
/

alter trigger syapex.ggops_configuration_files_biu enable;

