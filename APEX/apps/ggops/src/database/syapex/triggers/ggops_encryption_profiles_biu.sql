create or replace editionable trigger syapex.ggops_encryption_profiles_biu before
    insert or update on syapex.ggops_encryption_profiles
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
end ggops_encryption_profiles_biu;
/

alter trigger syapex.ggops_encryption_profiles_biu enable;


-- sqlcl_snapshot {"hash":"cfef4db95d1ec1e56ffa92598aafe99edb18315e","type":"TRIGGER","name":"GGOPS_ENCRYPTION_PROFILES_BIU","schemaName":"SYAPEX","sxml":""}