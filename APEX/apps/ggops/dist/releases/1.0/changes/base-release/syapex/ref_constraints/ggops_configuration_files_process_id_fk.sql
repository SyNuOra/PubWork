-- liquibase formatted sql
-- changeset SYAPEX:1771865126570 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_configuration_files_process_id_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_configuration_files_process_id_fk.sql:null:2a5bcd7e1d06cedf81e93c16c58b025c1d9bbfb0:create

alter table syapex.ggops_configuration_files
    add constraint ggops_configuration_files_process_id_fk
        foreign key ( process_id )
            references syapex.ggops_processes ( process_id )
                on delete cascade
        enable;

