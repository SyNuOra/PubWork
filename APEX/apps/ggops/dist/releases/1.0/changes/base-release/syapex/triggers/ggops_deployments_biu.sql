-- liquibase formatted sql
-- changeset SYAPEX:1771865128314 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_deployments_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_deployments_biu.sql:null:17411f69e4f8b2f1a1cef25de8884535303102bc:create

create or replace editionable trigger syapex.ggops_deployments_biu before
    insert or update on syapex.ggops_deployments
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
end ggops_deployments_biu;
/

alter trigger syapex.ggops_deployments_biu enable;

