alter table syapex.ggops_credentials
    add constraint ggops_credent_credential_do_fk
        foreign key ( credential_domain_id )
            references syapex.ggops_credential_domains ( domain_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"be557891e4ab33080217a315973ce656f8d809ce","type":"REF_CONSTRAINT","name":"GGOPS_CREDENT_CREDENTIAL_DO_FK","schemaName":"SYAPEX","sxml":""}