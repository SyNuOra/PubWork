alter table syapex.ggops_processes
    add constraint ggops_processes_deployment_fk
        foreign key ( deployment_id )
            references syapex.ggops_deployments ( deployment_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"51c31e34ba905c528e6f3c60e707466d7993da48","type":"REF_CONSTRAINT","name":"GGOPS_PROCESSES_DEPLOYMENT_FK","schemaName":"SYAPEX","sxml":""}