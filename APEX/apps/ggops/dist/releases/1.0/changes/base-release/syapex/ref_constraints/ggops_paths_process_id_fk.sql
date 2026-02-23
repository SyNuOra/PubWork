-- liquibase formatted sql
-- changeset SYAPEX:1771865126696 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_paths_process_id_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_paths_process_id_fk.sql:null:6772a20c27d3c0dd4f1a928256a85db4ccf6faa9:create

alter table syapex.ggops_paths
    add constraint ggops_paths_process_id_fk
        foreign key ( process_id )
            references syapex.ggops_processes ( process_id )
                on delete cascade
        enable;

