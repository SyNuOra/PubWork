alter table syapex.ggops_encryption_profiles
    add constraint ggops_encryptio_deployment_fk
        foreign key ( deployment_id )
            references syapex.ggops_deployments ( deployment_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"ca4f45a5c0aa820bbbd5630df66d515d7f3d8141","type":"REF_CONSTRAINT","name":"GGOPS_ENCRYPTIO_DEPLOYMENT_FK","schemaName":"SYAPEX","sxml":""}