alter table syapex.ggops_credential_domains
    add constraint ggops_credentia_deployment_fk
        foreign key ( deployment_id )
            references syapex.ggops_deployments ( deployment_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"9bf2417a453b03858c13c4e2d78efd2f73bb5053","type":"REF_CONSTRAINT","name":"GGOPS_CREDENTIA_DEPLOYMENT_FK","schemaName":"SYAPEX","sxml":""}