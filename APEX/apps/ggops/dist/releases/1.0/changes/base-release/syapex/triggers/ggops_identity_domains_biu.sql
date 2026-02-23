-- liquibase formatted sql
-- changeset SYAPEX:1771865128518 stripComments:false  logicalFilePath:base-release/syapex/triggers/ggops_identity_domains_biu.sql
-- sqlcl_snapshot src/database/syapex/triggers/ggops_identity_domains_biu.sql:null:67be761ad541d8eee47a55ade8f025c3801e36dd:create

create or replace editionable trigger syapex.ggops_identity_domains_biu before
    insert or update on syapex.ggops_identity_domains
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
end ggops_identity_domains_biu;
/

alter trigger syapex.ggops_identity_domains_biu enable;

