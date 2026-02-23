-- liquibase formatted sql
-- changeset SYAPEX:1771865128590 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_paths_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_paths_biu.sql:null:a7812813463b5b0c827e928772aa9402dc96159b:create

create or replace editionable trigger syapex.ggops_paths_biu before
    insert or update on syapex.ggops_paths
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
end ggops_paths_biu;
/

alter trigger syapex.ggops_paths_biu enable;

