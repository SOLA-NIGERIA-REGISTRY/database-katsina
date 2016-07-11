--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = system, pg_catalog;

--
-- Data for Name: config_map_layer_type; Type: TABLE DATA; Schema: system; Owner: postgres
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE config_map_layer_type DISABLE TRIGGER ALL;

INSERT INTO config_map_layer_type (code, display_value, status, description) VALUES ('wms', 'WMS server with layers::::Server WMS con layer::::::::::::::::::::', 'c', NULL);
INSERT INTO config_map_layer_type (code, display_value, status, description) VALUES ('shape', 'Shapefile::::Shapefile::::::::::::::::::::', 'c', NULL);
INSERT INTO config_map_layer_type (code, display_value, status, description) VALUES ('pojo', 'Pojo layer::::Pojo layer::::::::::::::::::::', 'c', NULL);
INSERT INTO config_map_layer_type (code, display_value, status, description) VALUES ('pojo_public_display', 'Pojo layer used for public display::::::::::::::::::::::::', 'c', 'It is an extension of pojo layer. It is used only during the public display map generation.::::::::::::::::::::::::');


ALTER TABLE config_map_layer_type ENABLE TRIGGER ALL;

--
-- Data for Name: query; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE query DISABLE TRIGGER ALL;

INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getParcelsPending', 'select co.id, co.name_firstpart || ''/'' || co.name_lastpart as label,  st_asewkb(st_transform(co.geom_polygon, #{srid})) as the_geom  from cadastre.cadastre_object co  where type_code= ''parcel'' and status_code= ''pending''   and ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid})) union select co.id, co.name_firstpart || ''/'' || co.name_lastpart as label,  st_asewkb(co_t.geom_polygon) as the_geom  from cadastre.cadastre_object co inner join cadastre.cadastre_object_target co_t on co.id = co_t.cadastre_object_id and co_t.geom_polygon is not null where ST_Intersects(co_t.geom_polygon, ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))       and co_t.transaction_id in (select id from transaction.transaction where status_code not in (''approved'')) ', NULL);
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getSurveyControls', 'select id, label, st_asewkb(st_transform(geom, #{srid})) as the_geom from cadastre.survey_control  where ST_Intersects(st_transform(geom, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getRoads', 'select id, label, st_asewkb(st_transform(geom, #{srid})) as the_geom from cadastre.road where ST_Intersects(st_transform(geom, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid})) and st_area(geom)> power(5 * #{pixel_res}, 2)', NULL);
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getPlaceNames', 'select id, label, st_asewkb(st_transform(geom, #{srid})) as the_geom from cadastre.place_name where ST_Intersects(st_transform(geom, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getApplications', 'select id, nr as label, st_asewkb(st_transform(location, #{srid})) as the_geom from application.application where ST_Intersects(st_transform(location, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('dynamic.informationtool.get_parcel', 'select co.id, co.name_firstpart || ''/'' || co.name_lastpart as parcel_nr,      (select string_agg(ba.name_firstpart || ''/'' || ba.name_lastpart, '','')      from administrative.ba_unit_contains_spatial_unit bas, administrative.ba_unit ba      where spatial_unit_id= co.id and bas.ba_unit_id= ba.id) as ba_units,      ( SELECT spatial_value_area.size FROM cadastre.spatial_value_area      WHERE spatial_value_area.type_code=''officialArea'' and spatial_value_area.spatial_unit_id = co.id) AS area_official_sqm,       st_asewkb(st_transform(co.geom_polygon, #{srid})) as the_geom      from cadastre.cadastre_object co      where type_code= ''parcel'' and status_code= ''current''      and ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('dynamic.informationtool.get_parcel_pending', 'select co.id, co.name_firstpart || ''/'' || co.name_lastpart as parcel_nr,       ( SELECT spatial_value_area.size FROM cadastre.spatial_value_area         WHERE spatial_value_area.type_code=''officialArea'' and spatial_value_area.spatial_unit_id = co.id) AS area_official_sqm,   st_asewkb(st_transform(co.geom_polygon, #{srid})) as the_geom    from cadastre.cadastre_object co  where type_code= ''parcel'' and ((status_code= ''pending''    and ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid})))   or (co.id in (select cadastre_object_id           from cadastre.cadastre_object_target co_t inner join transaction.transaction t on co_t.transaction_id=t.id           where ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid})) and t.status_code not in (''approved''))))', NULL);
INSERT INTO query (name, sql, description) VALUES ('dynamic.informationtool.get_place_name', 'select id, label,  st_asewkb(st_transform(geom, #{srid})) as the_geom from cadastre.place_name where ST_Intersects(st_transform(geom, #{srid}), ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('dynamic.informationtool.get_road', 'select id, label,  st_asewkb(st_transform(geom, #{srid})) as the_geom from cadastre.road where ST_Intersects(st_transform(geom, #{srid}), ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('dynamic.informationtool.get_application', 'select id, nr,  st_asewkb(st_transform(location, #{srid})) as the_geom from application.application where ST_Intersects(st_transform(location, #{srid}), ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('dynamic.informationtool.get_survey_control', 'select id, label,  st_asewkb(st_transform(geom, #{srid})) as the_geom from cadastre.survey_control where ST_Intersects(st_transform(geom, #{srid}), ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getParcelsHistoricWithCurrentBA', 'select co.id, co.name_firstpart || ''/'' || co.name_lastpart as label,  st_asewkb(st_transform(co.geom_polygon, #{srid})) as the_geom from cadastre.cadastre_object co inner join administrative.ba_unit_contains_spatial_unit ba_co on co.id = ba_co.spatial_unit_id   inner join administrative.ba_unit ba_unit on ba_unit.id= ba_co.ba_unit_id where co.type_code=''parcel'' and co.status_code= ''historic'' and ba_unit.status_code = ''current'' and ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 'select co.id, co.name_firstpart || ''/'' || co.name_lastpart as parcel_nr,         (select string_agg(ba.name_firstpart || ''/'' || ba.name_lastpart, '','')           from administrative.ba_unit_contains_spatial_unit bas, administrative.ba_unit ba           where spatial_unit_id= co.id and bas.ba_unit_id= ba.id) as ba_units,         (SELECT spatial_value_area.size      FROM cadastre.spatial_value_area           WHERE spatial_value_area.type_code=''officialArea'' and spatial_value_area.spatial_unit_id = co.id) AS area_official_sqm,         st_asewkb(st_transform(co.geom_polygon, #{srid})) as the_geom        from cadastre.cadastre_object co inner join administrative.ba_unit_contains_spatial_unit ba_co on co.id = ba_co.spatial_unit_id   inner join administrative.ba_unit ba_unit on ba_unit.id= ba_co.ba_unit_id where co.type_code=''parcel'' and co.status_code= ''historic'' and ba_unit.status_code = ''current''       and ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_GeomFromWKB(#{wkb_geom}), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('map_search.cadastre_object_by_number', 'select id, name_firstpart || ''/'' || name_lastpart as label, st_asewkb(st_transform(geom_polygon, #{srid})) as the_geom 
 from cadastre.cadastre_object  where status_code= ''current'' and compare_strings(#{search_string}, name_firstpart || '' '' || name_lastpart) and geom_polygon is not null limit 30', NULL);
INSERT INTO query (name, sql, description) VALUES ('map_search.cadastre_object_by_baunit', 'select distinct co.id,  ba_unit.name_firstpart || ''/ '' || ba_unit.name_lastpart || '' > '' || co.name_firstpart || ''/ '' || co.name_lastpart as label,  st_asewkb(st_transform(geom_polygon, #{srid})) as the_geom from cadastre.cadastre_object  co    inner join administrative.ba_unit_contains_spatial_unit bas on co.id = bas.spatial_unit_id     inner join administrative.ba_unit on ba_unit.id = bas.ba_unit_id  where (co.status_code= ''current'' or ba_unit.status_code= ''current'')    and compare_strings(#{search_string}, ba_unit.name_firstpart || '' '' || ba_unit.name_lastpart) limit 30', NULL);
INSERT INTO query (name, sql, description) VALUES ('map_search.cadastre_object_by_baunit_owner', 'select distinct co.id,  coalesce(party.name, '''') || '' '' || coalesce(party.last_name, '''') || '' > '' || co.name_firstpart || ''/ '' || co.name_lastpart as label,  st_asewkb(st_transform(co.geom_polygon, #{srid})) as the_geom  from cadastre.cadastre_object  co     inner join administrative.ba_unit_contains_spatial_unit bas on co.id = bas.spatial_unit_id     inner join administrative.ba_unit on bas.ba_unit_id= ba_unit.id     inner join administrative.rrr on (ba_unit.id = rrr.ba_unit_id and rrr.status_code = ''current'' and rrr.type_code = ''ownership'')     inner join administrative.party_for_rrr pfr on rrr.id = pfr.rrr_id     inner join party.party on pfr.party_id= party.id where (co.status_code= ''current'' or ba_unit.status_code= ''current'')     and compare_strings(#{search_string}, coalesce(party.name, '''') || '' '' || coalesce(party.last_name, '''')) limit 30', NULL);
INSERT INTO query (name, sql, description) VALUES ('system_search.cadastre_object_by_baunit_id', 'SELECT id,  name_firstpart || ''/ '' || name_lastpart as label, st_asewkb(st_transform(geom_polygon, #{srid})) as the_geom  FROM cadastre.cadastre_object WHERE transaction_id IN (  SELECT cot.transaction_id FROM (administrative.ba_unit_contains_spatial_unit ba_su     INNER JOIN cadastre.cadastre_object co ON ba_su.spatial_unit_id = co.id)     INNER JOIN cadastre.cadastre_object_target cot ON co.id = cot.cadastre_object_id     WHERE ba_su.ba_unit_id = #{search_string})  AND (SELECT COUNT(1) FROM administrative.ba_unit_contains_spatial_unit WHERE spatial_unit_id = cadastre_object.id) = 0 AND status_code = ''current''', 'Query used by BaUnitBean.loadNewParcels');
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getParcelNodes', 'select distinct st_astext(st_transform(geom, #{srid})) as id, '''' as label, st_asewkb(st_transform(geom, #{srid})) as the_geom from (select (ST_DumpPoints(geom_polygon)).* from cadastre.cadastre_object co  where type_code= ''parcel'' and status_code= ''current''  and ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))) tmp_table ', NULL);
INSERT INTO query (name, sql, description) VALUES ('public_display.parcels', 'select co.id, co.name_firstpart as label,  st_asewkb(st_transform(co.geom_polygon, #{srid})) as the_geom from cadastre.cadastre_object co where type_code= ''parcel'' and status_code= ''current'' and name_lastpart = #{name_lastpart} and ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', 'Query is used from public display map. It retrieves parcels being of a certain area (name_lastpart).');
INSERT INTO query (name, sql, description) VALUES ('public_display.parcels_next', 'SELECT co_next.id, co_next.name_firstpart as label,  st_asewkb(st_transform(co_next.geom_polygon, #{srid})) as the_geom  from cadastre.cadastre_object co_next, cadastre.cadastre_object co where co.type_code= ''parcel'' and co.status_code= ''current'' and co_next.type_code= ''parcel'' and co_next.status_code= ''current'' and co.name_lastpart = #{name_lastpart} and co_next.name_lastpart != #{name_lastpart} and st_dwithin(st_transform(co.geom_polygon, #{srid}), st_transform(co_next.geom_polygon, #{srid}), 5) and ST_Intersects(st_transform(co_next.geom_polygon, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', ' Query is used from public display map. It retrieves parcels being near the parcels of the layer public-display-parcels.');
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getHierarchy', 'select id, label, st_asewkb(geom) as the_geom, filter_category  from cadastre.hierarchy where ST_Intersects(geom, ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid})) and st_area(geom)> power(5 * #{pixel_res}, 2)', 'Query is used from Spatial Unit Group Editor to edit hierarchy records');
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getRoadCenterlines', 'select id, label, st_asewkb(st_transform(geom, #{srid})) as the_geom from cadastre.spatial_unit where level_id = ''road-centerline'' and ST_Intersects(st_transform(geom, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getHouseNum', 'select su.id, su.label,  st_asewkb(su.reference_point) as the_geom from cadastre.spatial_unit su, cadastre.level l where su.level_id = l.id and l."name" = ''House Number'' and ST_Intersects(su.reference_point, ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', NULL);
INSERT INTO query (name, sql, description) VALUES ('map_search.locality', 'SELECT co.id, a.description as label, st_asewkb(co.geom_polygon) as the_geom 
  FROM cadastre.cadastre_object co, cadastre.spatial_unit_address sa,
       address.address a
  WHERE co.id = sa.spatial_unit_id
  AND   a.id = sa.address_id  
  AND compare_strings(#{search_string}, a.description)
  AND co.geom_polygon IS NOT NULL
  ORDER BY a.description', NULL);
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getParcels', 'select co.id, co.name_firstpart || ''/'' || co.name_lastpart as label, 
st_asewkb(st_transform(co.geom_polygon,  #{srid})) as the_geom from cadastre.cadastre_object co where type_code= ''parcel'' and co.geom_polygon is not null
and status_code= ''current'' and ST_Intersects(st_transform(co.geom_polygon, #{srid}), ST_SetSRID(ST_3DMakeBox(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid})) and st_area(co.geom_polygon)> power(5 * #{pixel_res}, 2)', NULL);
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getLGA', 'select id, label, st_asewkb(geom) as the_geom from cadastre.lga where ST_Intersects(geom, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid})) and st_area(geom)> power(5 * #{pixel_res}, 2)', 'The spatial query that retrieves LGA');
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getWard', 'select id, label, st_asewkb(geom) as the_geom from cadastre.ward where ST_Intersects(geom, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid})) and st_area(geom)> power(5 * #{pixel_res}, 2)', 'The spatial query that retrieves Ward');
INSERT INTO query (name, sql, description) VALUES ('SpatialResult.getOverlappingParcels', 'SELECT co.id, co.name_firstpart as label,  st_asewkb(co.geom_polygon) as the_geom  
from cadastre.cadastre_object co, cadastre.cadastre_object co_int 
where co.type_code= ''parcel''  and co_int.type_code= ''parcel'' 
  and co.id > co_int.id
  and ST_Intersects(co.geom_polygon, st_buffer(co_int.geom_polygon, -0.03))
  and ST_Intersects(co.geom_polygon, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))
  and ST_Intersects(co_int.geom_polygon, ST_SetSRID(ST_MakeBox3D(ST_Point(#{minx}, #{miny}),ST_Point(#{maxx}, #{maxy})), #{srid}))', 'The spatial query that retrieves Overlapping');
INSERT INTO query (name, sql, description) VALUES ('map_search.cadastre_object_by_title', 'select distinct co.id,  ba_unit.name || '' > '' || co.name_firstpart || ''/ '' || co.name_lastpart as label,  st_asewkb(st_transform(geom_polygon, #{srid})) as the_geom from cadastre.cadastre_object  co    inner join administrative.ba_unit_contains_spatial_unit bas on co.id = bas.spatial_unit_id     inner join administrative.ba_unit on ba_unit.id = bas.ba_unit_id  where (co.status_code= ''current'' or ba_unit.status_code= ''current'') and ba_unit.name is not null   and compare_strings(#{search_string}, ba_unit.name) limit 30', NULL);


ALTER TABLE query ENABLE TRIGGER ALL;

--
-- Data for Name: config_map_layer; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE config_map_layer DISABLE TRIGGER ALL;

INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('place-names', 'Places names::::Nomi di luoghi', 'pojo', true, true, 60, 'place_name.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Point,label:""', 'SpatialResult.getPlaceNames', 'dynamic.informationtool.get_place_name', NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('public-display-parcels', 'Public display parcels', 'pojo_public_display', true, true, 35, 'public_display_parcel.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:""', 'public_display.parcels', NULL, NULL, NULL, NULL, false, true, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('public-display-parcels-next', 'Other Systematic Registration Parcels', 'pojo_public_display', true, true, 30, 'public_display_parcel_next.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:""', 'public_display.parcels_next', NULL, NULL, NULL, NULL, false, true, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('house_num', 'House number', 'pojo', true, false, 43, 'house_num.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Point,label:""', 'SpatialResult.getHouseNum', NULL, NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('road-centerlines', 'Road centerlines', 'pojo', true, true, 45, 'road_centerline.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:MultiLineString,label:""', 'SpatialResult.getRoadCenterlines', NULL, NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('pending-parcels', 'Pending parcels::::Particelle pendenti', 'pojo', true, false, 30, 'pending_parcels.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:""', 'SpatialResult.getParcelsPending', 'dynamic.informationtool.get_parcel_pending', NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('roads', 'Roads::::Strade', 'pojo', true, false, 40, 'road.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:MultiPolygon,label:""', 'SpatialResult.getRoads', 'dynamic.informationtool.get_road', NULL, NULL, NULL, false, true, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('survey-controls', 'Survey controls::::Piani di controllo', 'pojo', true, false, 50, 'survey_control.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Point,label:""', 'SpatialResult.getSurveyControls', 'dynamic.informationtool.get_survey_control', NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('applications', 'Applications::::Pratiche', 'pojo', true, false, 70, 'application.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:MultiPoint,label:""', 'SpatialResult.getApplications', 'dynamic.informationtool.get_application', NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('parcel-nodes', 'Parcel nodes', 'pojo', true, false, 15, 'parcel_node.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:""', 'SpatialResult.getParcelNodes', NULL, NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('claims-orthophoto', 'Claims::::::::::::::::::::::::::::::::', 'wms', true, false, 12, '', 'http://localhost:8085/geoserver/opentenure/wms', 'opentenure:claims', '1.1.1', 'image/png', '', '', NULL, NULL, '', '', '', false, false, true);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('parcels', 'Parcels::::Particelle', 'pojo', true, true, 100, 'parcel.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:""', 'SpatialResult.getParcels', 'dynamic.informationtool.get_parcel', NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('orthophoto', 'Orthophoto', 'wms', false, true, 10, NULL, 'http://localhost:8085/geoserver/sola/wms', 'katsina:katsina', '1.1.1', 'image/jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('sug_lga', 'Local Government Areas', 'pojo', true, true, 90, 'lga.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:""', 'SpatialResult.getLGA', NULL, NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('sug_ward', 'Ward', 'pojo', true, true, 80, 'ward.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:""', 'SpatialResult.getWard', NULL, NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('parcels-historic-current-ba', 'Historic parcels with current titles', 'pojo', false, false, 20, 'parcel_historic_current_ba.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:""', 'SpatialResult.getParcelsHistoricWithCurrentBA', 'dynamic.informationtool.get_parcel_historic_current_ba', NULL, NULL, NULL, false, false, false);
INSERT INTO config_map_layer (name, title, type_code, active, visible_in_start, item_order, style, url, wms_layers, wms_version, wms_format, wms_data_source, pojo_structure, pojo_query_name, pojo_query_name_for_select, shape_location, security_user, security_password, added_from_bulk_operation, use_in_public_display, use_for_ot) VALUES ('sug_hierarchy', 'Hierarchy', 'pojo', false, false, 9, 'sug-hierarchy.xml', NULL, NULL, NULL, NULL, NULL, 'theGeom:Polygon,label:"",filter_category', 'SpatialResult.getHierarchy', NULL, NULL, NULL, NULL, false, true, false);


ALTER TABLE config_map_layer ENABLE TRIGGER ALL;

--
-- Data for Name: config_map_layer_metadata; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE config_map_layer_metadata DISABLE TRIGGER ALL;

INSERT INTO config_map_layer_metadata (name_layer, name, value, for_client) VALUES ('claims-orthophoto', 'transparent', 'true', false);
INSERT INTO config_map_layer_metadata (name_layer, name, value, for_client) VALUES ('claims-orthophoto', 'LEGEND_OPTIONS', 'fontSize:12', false);
INSERT INTO config_map_layer_metadata (name_layer, name, value, for_client) VALUES ('claims-orthophoto', 'singleTile', 'true', true);
INSERT INTO config_map_layer_metadata (name_layer, name, value, for_client) VALUES ('orthophoto', 'date', 'TBU DATE ??', false);
INSERT INTO config_map_layer_metadata (name_layer, name, value, for_client) VALUES ('orthophoto', 'resolution', 'TBU 50 cm ??', false);
INSERT INTO config_map_layer_metadata (name_layer, name, value, for_client) VALUES ('orthophoto', 'data-source', 'TBU DATUM ??', false);


ALTER TABLE config_map_layer_metadata ENABLE TRIGGER ALL;

--
-- Data for Name: panel_launcher_group; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE panel_launcher_group DISABLE TRIGGER ALL;

INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('recordRelationship', 'Record Relationship::::::::تسجيل العلاقة::::::::::::::::记录关系', 'Panels used for relationship services::::::::لوحة تستخدم لحدمات العلاقات::::::::::::::::用于关系服务的面板', 'c');
INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('nullConstructor', 'Nullary Constructor::::::::منشئ بدون مدخلات::::::::::::::::默认的构造函数', 'Panels that do not take any constructor arguments::::::::لوحة لا تأخد اية مدخلات عند المنشئ::::::::::::::::不带任何构造函数参数的面板', 'c');
INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('cadastreServices', 'Cadastre Services::::::::خدمات المساحة::::::::::::::::地籍服务', 'Panels used for cadastre services::::::::لوحة تستخدم لخدمات المساحة::::::::::::::::用于地籍服务的面板', 'c');
INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('cancelRelationship', 'Cancel Relationship::::::::الغاء الصلة::::::::::::::::取消关系', 'Panels used for cancel relationship services::::::::لوحة تستخدم  لخدمات الغاء الملكية::::::::::::::::用于取消关系服务的面板', 'c');
INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('documentServices', 'Document Services::::::::خدمات الوثيقة::::::::::::::::文件服务', 'Panels used for document services::::::::لوحة تستخدم لخدمات الوثائق::::::::::::::::用于文档服务的面板', 'c');
INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('generalRRR', 'General RRR::::::::  (الحقوق , القيود , )::::::::::::::::普通 RRR', 'Panels used for general RRRs::::::::لوحة تستخدم لخدمات الحقوق العامة::::::::::::::::用于普通权利限制与责任的面板', 'c');
INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('leaseRRR', 'Lease RRR::::::::أيجار RRR::::::::::::::::租赁权利限制域责任', 'Panels used for Lease RRR::::::::لوحة تستخدم لخدمات  حقوق الأيجار::::::::::::::::用于租赁权利限制与责任的面板', 'c');
INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('newPropServices', 'New Property Services::::::::خدمات ملكية جديدة::::::::::::::::新的财产服务', 'Panels used for new property services::::::::لوحة تستخدم لخدمات ملكيات جديدة ::::::::::::::::用于新的财产服务的面板', 'c');
INSERT INTO panel_launcher_group (code, display_value, description, status) VALUES ('propertyServices', 'Property Services::::::::خدمات  الأملاك::::::::::::::::财产服务', 'Panels used for property services::::::::لوحة تستخدم لخدمات الاملاك::::::::::::::::用于财产服务的面板', 'c');


ALTER TABLE panel_launcher_group ENABLE TRIGGER ALL;

--
-- Data for Name: config_panel_launcher; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE config_panel_launcher DISABLE TRIGGER ALL;

INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('partySearch', 'Party Search Panel::::::::::::::::::::::::', NULL, 'c', 'nullConstructor', 'org.sola.clients.swing.desktop.party.PartySearchPanelForm', 'cliprgs008', 'searchPersons');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('cadastreTransMap', 'Cadastre Transaction Map Panel::::::::لوحة حركات خارطة المساحة::::::::::::::::地籍交易图面板', NULL, 'c', 'cadastreServices', 'org.sola.clients.swing.desktop.cadastre.CadastreTransactionMapPanel', 'cliprgs017', 'cadastreChange');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('cancelRelationship', 'Cancel Relationship::::::::الغاء الصلة::::::::::::::::取消关系', '::::::::::::::::::::::::', 'c', 'cancelRelationship', 'org.sola.clients.swing.desktop.administrative.CancelPersonRelationshipPanel', 'cliprgs009', 'cancelRelationship');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('documentSearch', 'Document Search Panel::::::::لوحة البحث عن الوثائق::::::::::::::::文档搜索面板', NULL, 'c', 'nullConstructor', 'org.sola.clients.swing.desktop.source.DocumentSearchForm', 'cliprgs007', 'documentsearch');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('documentTrans', 'Document Transaction Panel::::::::لوحة حركات الوثيقة::::::::::::::::文件交易面板', NULL, 'c', 'documentServices', 'org.sola.clients.swing.desktop.source.TransactionedDocumentsPanel', 'cliprgs016', 'transactionedDocumentPanel');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('lease', 'Lease Panel::::::::لوحة الأيجار::::::::::::::::租赁面板', NULL, 'c', 'leaseRRR', 'org.sola.clients.swing.desktop.administrative.LeasePanel', NULL, 'leasePanel');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('map', 'Map Panel::::::::لوحة الخارطة::::::::::::::::地图面板', NULL, 'c', 'nullConstructor', 'org.sola.clients.swing.desktop.cadastre.MapPanelForm', 'cliprgs004', 'map');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('mortgage', 'Mortgage Panel::::::::لوحة الرهن::::::::::::::::抵押面板', NULL, 'c', 'generalRRR', 'org.sola.clients.swing.desktop.administrative.MortgagePanel', NULL, 'mortgagePanel');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('newProperty', 'New Property Panel::::::::لوحة ملكية جديدة::::::::::::::::新的财产面板', NULL, 'c', 'newPropServices', 'org.sola.clients.swing.desktop.administrative.PropertyPanel', 'cliprgs009', 'propertyPanel');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('ownership', 'Ownership Share Panel::::::::لوحة ملكية الحصص::::::::::::::::所有权共享面板', NULL, 'c', 'generalRRR', 'org.sola.clients.swing.desktop.administrative.OwnershipPanel', NULL, 'ownershipPanel');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('property', 'Property Panel::::::::لوحة الملكيات::::::::::::::::财产面板', NULL, 'c', 'propertyServices', 'org.sola.clients.swing.desktop.administrative.PropertyPanel', 'cliprgs009', 'propertyPanel');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('propertySearch', 'Property Search Panel::::::::لوحة البحث عن ملكية::::::::::::::::财产搜索面板', NULL, 'c', 'nullConstructor', 'org.sola.clients.swing.desktop.administrative.BaUnitSearchPanel', 'cliprgs006', 'baunitsearch');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('recordRelationship', 'Record Relationship::::::::تسجيل العلاقة::::::::::::::::记录关系', '::::::::::::::::::::::::', 'c', 'recordRelationship', 'org.sola.clients.swing.desktop.administrative.RecordPersonRelationshipPanel', 'cliprgs009', 'recordRelationship');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('simpleRight', 'Simple Right Panel::::::::لوحة الحق البسيط::::::::::::::::简单的权利面板', NULL, 'c', 'generalRRR', 'org.sola.clients.swing.desktop.administrative.SimpleRightPanel', NULL, 'simpleRightPanel');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('simpleRightholder', 'Simple Rightholder Panel::::::::لوحة أصحاب الحق البسيط::::::::::::::::简单的权利所有者面板', NULL, 'c', 'generalRRR', 'org.sola.clients.swing.desktop.administrative.SimpleRightholderPanel', NULL, 'simpleOwnershipPanel');
INSERT INTO config_panel_launcher (code, display_value, description, status, launch_group, panel_class, message_code, card_name) VALUES ('applicationSearch', 'Application Search Panel::::::::لوحة البحث عن طلب::::::::::::::::申请搜索面板', NULL, 'c', 'nullConstructor', 'org.sola.clients.swing.desktop.application.ApplicationSearchPanel', 'cliprgs003', 'appsearch');


ALTER TABLE config_panel_launcher ENABLE TRIGGER ALL;

--
-- Data for Name: consolidation_config; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE consolidation_config DISABLE TRIGGER ALL;

INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.application', 'application', 'application', 'Applications that have the status = “to-be-transferred”.', 'status_code = ''to-be-transferred'' and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''application.application'')', false, 1, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.service', 'application', 'service', 'Every service that belongs to the application being selected for transfer.', 'application_id in (select id from consolidation.application) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''application.service'')', false, 2, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('transaction.transaction', 'transaction', 'transaction', 'Every record that references a record in consolidation.service.', 'from_service_id in (select id from consolidation.service) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''transaction.transaction'')', false, 3, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('transaction.transaction_source', 'transaction', 'transaction_source', 'Every record that references a record in consolidation.transaction.', 'transaction_id in (select id from consolidation.transaction) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''transaction.transaction_source'')', false, 4, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.cadastre_object_target', 'cadastre', 'cadastre_object_target', 'Every record that references a record in consolidation.transaction.', 'transaction_id in (select id from consolidation.transaction) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.cadastre_object_target'')', false, 5, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.cadastre_object_node_target', 'cadastre', 'cadastre_object_node_target', 'Every record that references a record in consolidation.transaction.', 'transaction_id in (select id from consolidation.transaction) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.cadastre_object_node_target'')', false, 6, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.application_uses_source', 'application', 'application_uses_source', 'Every record that belongs to the application being selected for transfer.', 'application_id in (select id from consolidation.application) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''application.application_uses_source'')', false, 7, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.application_property', 'application', 'application_property', 'Every record that belongs to the application being selected for transfer.', 'application_id in (select id from consolidation.application) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''application.application_property'')', false, 8, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.application_spatial_unit', 'application', 'application_spatial_unit', 'Every record that belongs to the application being selected for transfer.', 'application_id in (select id from consolidation.application) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''application.application_spatial_unit'')', false, 9, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_unit', 'cadastre', 'spatial_unit', 'Every record that is referenced from application_spatial_unit or that is a targeted from a service already extracted or created from a service already extracted in consolidation schema.', '(id in (select spatial_unit_id from consolidation.application_spatial_unit) 
or id in (select id from cadastre.cadastre_object where transaction_id in (select id from consolidation.transaction))
or id in (select cadastre_object_id from consolidation.cadastre_object_target)
) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.spatial_unit'')', false, 10, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_unit_in_group', 'cadastre', 'spatial_unit_in_group', 'Every record that references a record in consolidation.spatial_unit', 'spatial_unit_id in (select id from consolidation.spatial_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.spatial_unit_in_group'')', false, 11, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.cadastre_object', 'cadastre', 'cadastre_object', 'Every record that is also in consolidation.spatial_unit', 'id in (select id from consolidation.spatial_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.cadastre_object'')', false, 12, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_unit_address', 'cadastre', 'spatial_unit_address', 'Every record that references a record in consolidation.spatial_unit.', 'spatial_unit_id in (select id from consolidation.spatial_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.spatial_unit_address'')', false, 13, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_value_area', 'cadastre', 'spatial_value_area', 'Every record that references a record in consolidation.spatial_unit.', 'spatial_unit_id in (select id from consolidation.spatial_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.spatial_value_area'')', false, 14, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.survey_point', 'cadastre', 'survey_point', 'Every record that references a record in consolidation.transaction.', 'transaction_id in (select id from consolidation.transaction) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.survey_point'')', false, 15, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.legal_space_utility_network', 'cadastre', 'legal_space_utility_network', 'Every record that is also in consolidation.spatial_unit', 'id in (select id from consolidation.spatial_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''cadastre.legal_space_utility_network'')', false, 16, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_unit_group', 'cadastre', 'spatial_unit_group', 'Every record', NULL, true, 17, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit_contains_spatial_unit', 'administrative', 'ba_unit_contains_spatial_unit', 'Every record that references a record in consolidation.cadastre_object.', 'spatial_unit_id in (select id from consolidation.cadastre_object) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.ba_unit_contains_spatial_unit'')', false, 18, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.source_historic', 'source', 'source_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.source)', true, 43, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit_target', 'administrative', 'ba_unit_target', 'Every record that references a record in consolidation.transaction.', 'transaction_id in (select id from consolidation.transaction) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.ba_unit_target'')', false, 19, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit', 'administrative', 'ba_unit', 'Every record that is referenced by consolidation.application_property or consolidation.ba_unit_contains_spatial_unit or consolidation.ba_unit_target.', '(id in (select ba_unit_id from consolidation.application_property) or id in (select ba_unit_id from consolidation.ba_unit_contains_spatial_unit) or id in (select ba_unit_id from consolidation.ba_unit_target)) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.ba_unit'')', false, 20, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.required_relationship_baunit', 'administrative', 'required_relationship_baunit', 'Every record that references a record in consolidation.ba_unit.', 'from_ba_unit_id in (select id from consolidation.ba_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.required_relationship_baunit'')', false, 21, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit_area', 'administrative', 'ba_unit_area', 'Every record that references a record in consolidation.ba_unit.', 'ba_unit_id in (select id from consolidation.ba_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.ba_unit_area'')', false, 22, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit_as_party', 'administrative', 'ba_unit_as_party', 'Every record that references a record in consolidation.ba_unit.', 'ba_unit_id in (select id from consolidation.ba_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.ba_unit_as_party'')', false, 23, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.source_describes_ba_unit', 'administrative', 'source_describes_ba_unit', 'Every record that references a record in consolidation.ba_unit.', 'ba_unit_id in (select id from consolidation.ba_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.source_describes_ba_unit'')', false, 24, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.rrr', 'administrative', 'rrr', 'Every record that references a record in consolidation.ba_unit.', 'ba_unit_id in (select id from consolidation.ba_unit) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.rrr'')', false, 25, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.rrr_share', 'administrative', 'rrr_share', 'Every record that references a record in consolidation.rrr.', 'rrr_id in (select id from consolidation.rrr) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.rrr_share'')', false, 26, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.party_for_rrr', 'administrative', 'party_for_rrr', 'Every record that references a record in consolidation.rrr.', 'rrr_id in (select id from consolidation.rrr) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.party_for_rrr'')', false, 27, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.condition_for_rrr', 'administrative', 'condition_for_rrr', 'Every record that references a record in consolidation.rrr.', 'rrr_id in (select id from consolidation.rrr) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.condition_for_rrr'')', false, 28, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.mortgage_isbased_in_rrr', 'administrative', 'mortgage_isbased_in_rrr', 'Every record that references a record in consolidation.rrr.', 'rrr_id in (select id from consolidation.rrr) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.mortgage_isbased_in_rrr'')', false, 29, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.source_describes_rrr', 'administrative', 'source_describes_rrr', 'Every record that references a record in consolidation.rrr.', 'rrr_id in (select id from consolidation.rrr) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.source_describes_rrr'')', false, 30, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.notation', 'administrative', 'notation', 'Every record that references a record in consolidation.ba_unit or consolidation.rrr or consolidation.transaction.', '(ba_unit_id in (select id from consolidation.ba_unit) or rrr_id in (select id from consolidation.rrr) or transaction_id in (select id from consolidation.transaction)) and rowidentifier not in (select rowidentifier from system.extracted_rows where table_name=''administrative.notation'')', false, 31, true);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.source', 'source', 'source', 'Every source that is referenced from the consolidation.application_uses_source 
or consolidation.transaction_source
or source that references consolidation.transaction or source that is referenced from consolidation.source_describes_ba_unit or source that is referenced from consolidation.source_describes_rrr.', 'id in (select source_id from consolidation.application_uses_source)
or id in (select source_id from consolidation.transaction_source)
or transaction_id in (select id from consolidation.transaction)
or id in (select source_id from consolidation.source_describes_ba_unit)
or id in (select source_id from consolidation.source_describes_rrr) ', true, 32, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.power_of_attorney', 'source', 'power_of_attorney', 'Every record that is also in consolidation.source.', 'id in (select id from consolidation.source)', true, 33, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.spatial_source', 'source', 'spatial_source', 'Every record that is also in consolidation.source.', 'id in (select id from consolidation.source)', true, 34, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.spatial_source_measurement', 'source', 'spatial_source_measurement', 'Every record that references a record in consolidation.spatial_source.', 'spatial_source_id in (select id from consolidation.spatial_source)', true, 35, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.archive', 'source', 'archive', 'Every record that is referenced from a record in consolidation.source.', 'id in (select archive_id from consolidation.source) ', true, 36, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('document.document', 'document', 'document', 'Every record that is referenced by consolidation.source.', 'id in (select ext_archive_id from consolidation.source)', true, 37, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('party.party', 'party', 'party', 'Every record that is referenced by consolidation.application or consolidation.ba_unit_as_party or consolidation.party_for_rrr.', 'id in (select agent_id from consolidation.application) or id in (select contact_person_id from consolidation.application) or id in (select agent_id from consolidation.application) or id in (select party_id from consolidation.party_for_rrr) or id in (select party_id from consolidation.ba_unit_as_party)', true, 38, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('party.group_party', 'party', 'group_party', 'Every record that is also in consolidation.party.', 'id in (select id from consolidation.party)', true, 39, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('party.party_member', 'party', 'party_member', 'Every record that references a record in consolidation.party.', 'party_id in (select id from consolidation.party)', true, 40, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('party.party_role', 'party', 'party_role', 'Every record that references a record in consolidation.party.', 'party_id in (select id from consolidation.party)', true, 41, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('address.address', 'address', 'address', 'Every record that is referenced by consolidation.party or consolidation.spatial_unit_address.', 'id in (select address_id from consolidation.party) or id in (select address_id from consolidation.spatial_unit_address)', true, 42, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.survey_point_historic', 'cadastre', 'survey_point_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.survey_point)', false, 44, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_value_area_historic', 'cadastre', 'spatial_value_area_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.spatial_value_area)', false, 45, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_unit_address_historic', 'cadastre', 'spatial_unit_address_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.spatial_unit_address)', false, 46, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.spatial_source_measurement_historic', 'source', 'spatial_source_measurement_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.spatial_source_measurement)', false, 47, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.spatial_source_historic', 'source', 'spatial_source_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.spatial_source)', true, 48, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.source_describes_rrr_historic', 'administrative', 'source_describes_rrr_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.source_describes_rrr)', false, 49, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.rrr_historic', 'administrative', 'rrr_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.rrr)', false, 50, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.required_relationship_baunit_historic', 'administrative', 'required_relationship_baunit_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.required_relationship_baunit)', false, 51, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.power_of_attorney_historic', 'source', 'power_of_attorney_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.power_of_attorney)', true, 52, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('party.party_role_historic', 'party', 'party_role_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.party_role)', true, 53, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('party.party_member_historic', 'party', 'party_member_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.party_member)', true, 54, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.party_for_rrr_historic', 'administrative', 'party_for_rrr_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.party_for_rrr)', false, 55, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.legal_space_utility_network_historic', 'cadastre', 'legal_space_utility_network_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.legal_space_utility_network)', false, 56, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('party.group_party_historic', 'party', 'group_party_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.group_party)', true, 57, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.condition_for_rrr_historic', 'administrative', 'condition_for_rrr_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.condition_for_rrr)', false, 58, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.cadastre_object_historic', 'cadastre', 'cadastre_object_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.cadastre_object)', false, 59, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit_target_historic', 'administrative', 'ba_unit_target_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.ba_unit_target)', false, 60, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit_contains_spatial_unit_historic', 'administrative', 'ba_unit_contains_spatial_unit_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.ba_unit_contains_spatial_unit)', false, 61, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit_area_historic', 'administrative', 'ba_unit_area_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.ba_unit_area)', false, 62, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('source.archive_historic', 'source', 'archive_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.archive)', true, 63, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.application_property_historic', 'application', 'application_property_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.application_property)', false, 64, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.application_historic', 'application', 'application_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.application)', false, 65, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('transaction.transaction_source_historic', 'transaction', 'transaction_source_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.transaction_source)', false, 66, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('transaction.transaction_historic', 'transaction', 'transaction_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.transaction)', false, 67, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_unit_in_group_historic', 'cadastre', 'spatial_unit_in_group_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.spatial_unit_in_group)', false, 68, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_unit_group_historic', 'cadastre', 'spatial_unit_group_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.spatial_unit_group)', false, 69, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.spatial_unit_historic', 'cadastre', 'spatial_unit_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.spatial_unit)', false, 70, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.source_describes_ba_unit_historic', 'administrative', 'source_describes_ba_unit_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.source_describes_ba_unit)', false, 71, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.service_historic', 'application', 'service_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.service)', false, 72, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.rrr_share_historic', 'administrative', 'rrr_share_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.rrr_share)', false, 73, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('party.party_historic', 'party', 'party_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.party)', true, 74, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.notation_historic', 'administrative', 'notation_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.notation)', false, 75, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.mortgage_isbased_in_rrr_historic', 'administrative', 'mortgage_isbased_in_rrr_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.mortgage_isbased_in_rrr)', false, 76, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('document.document_historic', 'document', 'document_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.document)', true, 77, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.cadastre_object_target_historic', 'cadastre', 'cadastre_object_target_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.cadastre_object_target)', false, 78, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('cadastre.cadastre_object_node_target_historic', 'cadastre', 'cadastre_object_node_target_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.cadastre_object_node_target)', false, 79, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('administrative.ba_unit_historic', 'administrative', 'ba_unit_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.ba_unit)', false, 80, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.application_uses_source_historic', 'application', 'application_uses_source_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.application_uses_source)', false, 81, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('application.application_spatial_unit_historic', 'application', 'application_spatial_unit_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.application_spatial_unit)', false, 82, false);
INSERT INTO consolidation_config (id, schema_name, table_name, condition_description, condition_sql, remove_before_insert, order_of_execution, log_in_extracted_rows) VALUES ('address.address_historic', 'address', 'address_historic', 'Every record that references a record in the main table in consolidation schema.', 'rowidentifier in (select rowidentifier from consolidation.address)', false, 83, false);


ALTER TABLE consolidation_config ENABLE TRIGGER ALL;

--
-- Data for Name: crs; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE crs DISABLE TRIGGER ALL;

INSERT INTO crs (srid, from_long, to_long, item_order) VALUES (32632, 0, 171805.08555444199, 1);


ALTER TABLE crs ENABLE TRIGGER ALL;

--
-- Data for Name: map_search_option; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE map_search_option DISABLE TRIGGER ALL;

INSERT INTO map_search_option (code, title, query_name, active, min_search_str_len, zoom_in_buffer, description) VALUES ('LOCALITY', 'Locality', 'map_search.locality', true, 3, 100.00, NULL);
INSERT INTO map_search_option (code, title, query_name, active, min_search_str_len, zoom_in_buffer, description) VALUES ('BAUNIT', 'Property number', 'map_search.cadastre_object_by_baunit', true, 3, 50.00, NULL);
INSERT INTO map_search_option (code, title, query_name, active, min_search_str_len, zoom_in_buffer, description) VALUES ('OWNER_OF_BAUNIT', 'Property owner', 'map_search.cadastre_object_by_baunit_owner', false, 3, 50.00, NULL);
INSERT INTO map_search_option (code, title, query_name, active, min_search_str_len, zoom_in_buffer, description) VALUES ('NUMBER', 'Parcel', 'map_search.cadastre_object_by_number', true, 3, 50.00, NULL);
INSERT INTO map_search_option (code, title, query_name, active, min_search_str_len, zoom_in_buffer, description) VALUES ('TITLE', 'Title', 'map_search.cadastre_object_by_title', true, 3, 50.00, NULL);


ALTER TABLE map_search_option ENABLE TRIGGER ALL;

--
-- Data for Name: query_field; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE query_field DISABLE TRIGGER ALL;

INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel', 1, 'parcel_nr', 'Parcel number::::Numero Particella');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel', 2, 'ba_units', 'Properties::::Proprieta');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel', 3, 'area_official_sqm', 'Official area (m2)::::Area ufficiale (m2)');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel', 0, 'id', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel', 4, 'the_geom', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_pending', 0, 'id', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_pending', 1, 'parcel_nr', 'Parcel number::::Numero Particella');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_pending', 2, 'area_official_sqm', 'Official area (m2)::::Area ufficiale (m2)');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_pending', 3, 'the_geom', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_place_name', 0, 'id', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_place_name', 1, 'label', 'Name::::Nome');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_place_name', 2, 'the_geom', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_road', 0, 'id', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_road', 1, 'label', 'Name::::Nome');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_road', 2, 'the_geom', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_application', 0, 'id', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_application', 1, 'nr', 'Number::::Numero');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_application', 2, 'the_geom', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_survey_control', 0, 'id', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_survey_control', 1, 'label', 'Label::::Etichetta');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_survey_control', 2, 'the_geom', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 0, 'id', NULL);
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 1, 'parcel_nr', 'Parcel number::::Numero Particella');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 2, 'ba_units', 'Properties::::Proprieta');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 3, 'area_official_sqm', 'Official area (m2)::::Area ufficiale (m2)');
INSERT INTO query_field (query_name, index_in_query, name, display_value) VALUES ('dynamic.informationtool.get_parcel_historic_current_ba', 4, 'the_geom', NULL);


ALTER TABLE query_field ENABLE TRIGGER ALL;

--
-- Data for Name: setting; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE setting DISABLE TRIGGER ALL;

INSERT INTO setting (name, vl, active, description) VALUES ('map-tolerance', '0.01', true, 'The tolerance that is used while snapping geometries to each other. If two points are within this distance are considered being in the same location.');
INSERT INTO setting (name, vl, active, description) VALUES ('map-shift-tolerance-rural', '20', true, 'The shift tolerance of boundary points used in cadastre change in rural areas.');
INSERT INTO setting (name, vl, active, description) VALUES ('map-shift-tolerance-urban', '5', true, 'The shift tolerance of boundary points used in cadastre change in urban areas.');
INSERT INTO setting (name, vl, active, description) VALUES ('public-notification-duration', '30', true, 'The notification duration for the public display.');
INSERT INTO setting (name, vl, active, description) VALUES ('max-file-size', '10000', true, 'Maximum file size in KB for uploading.');
INSERT INTO setting (name, vl, active, description) VALUES ('max-uploading-daily-limit', '100000', true, 'Maximum size of files uploaded daily.');
INSERT INTO setting (name, vl, active, description) VALUES ('moderation-days', '30', true, 'Duration of moderation time in days');
INSERT INTO setting (name, vl, active, description) VALUES ('email-admin-address', '', true, 'Email address of server administrator. If empty, no notifications will be sent');
INSERT INTO setting (name, vl, active, description) VALUES ('email-admin-name', '', true, 'Name of server administrator');
INSERT INTO setting (name, vl, active, description) VALUES ('email-body-format', 'html', true, 'Message body format. text - for simple text format, html - for html format');
INSERT INTO setting (name, vl, active, description) VALUES ('email-send-interval1', '1', true, 'Time interval in minutes for the first attempt to send email message.');
INSERT INTO setting (name, vl, active, description) VALUES ('email-send-attempts1', '2', true, 'Number of attempts to send email with first interval');
INSERT INTO setting (name, vl, active, description) VALUES ('email-send-interval2', '120', true, 'Time interval in minutes for the second attempt to send email message.');
INSERT INTO setting (name, vl, active, description) VALUES ('email-send-attempts2', '2', true, 'Number of attempts to send email with second interval');
INSERT INTO setting (name, vl, active, description) VALUES ('email-send-interval3', '1440', true, 'Time interval in minutes for the third attempt to send email message.');
INSERT INTO setting (name, vl, active, description) VALUES ('email-send-attempts3', '1', true, 'Number of attempts to send email with third interval');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-failed-send-subject', 'Delivery failure', true, 'Subject text for delivery failure of message');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-failed-send-body', 'Message send to the user #{userName} has been failed to deliver after number of attempts with the following error: <br/>#{error}', true, 'Message text for delivery failure');
INSERT INTO setting (name, vl, active, description) VALUES ('account-activation-timeout', '70', true, 'Account activation timeout in hours. After this time, activation should expire.');
INSERT INTO setting (name, vl, active, description) VALUES ('email-service-interval', '10', true, 'Time interval in seconds for email service to check and process scheduled messages.');
INSERT INTO setting (name, vl, active, description) VALUES ('pword-expiry-days', '90', false, 'The number of days a users password remains valid');
INSERT INTO setting (name, vl, active, description) VALUES ('email-enable-email-service', '0', true, 'Enables or disables email service. 1 - enable, 0 - disable');
INSERT INTO setting (name, vl, active, description) VALUES ('ot-community-area', 'POLYGON((175.068823 -36.785949,175.070902 -36.786461,175.079644 -36.787528,175.087001 -36.788041,175.090519 -36.787699,175.092118 -36.787101,175.093344 -36.785564,175.094677 -36.784967,175.096862 -36.785564,175.097875 -36.786290,175.102033 -36.784967,175.103366 -36.784796,175.106138 -36.782917,175.106991 -36.781636,175.117919 -36.784540,175.117274 -36.830375,175.113668 -36.831440,175.112302 -36.829328,175.109315 -36.828175,175.108238 -36.824562,175.107966 -36.821181,175.107092 -36.820481,175.104627 -36.821072,175.103862 -36.823171,175.101666 -36.827659,175.098931 -36.826071,175.097525 -36.828629,175.094896 -36.831006,175.094560 -36.832145,175.095884 -36.833196,175.093828 -36.836375,175.086922 -36.837365,175.085134 -36.834587,175.081358 -36.833326,175.078821 -36.834071,175.077160 -36.835777,175.075854 -36.836182,175.073712 -36.835163,175.071524 -36.836100,175.070229 -36.833666,175.068580 -36.834116,175.063665 -36.831845,175.064985 -36.830216,175.066285 -36.829052,175.066763 -36.826629,175.070516 -36.828458,175.072053 -36.826502,175.072377 -36.823365,175.071137 -36.820436,175.068876 -36.818138,175.068876 -36.807121,175.068876 -36.807121,175.068876 -36.807121,175.068876 -36.805628,175.068876 -36.805628,175.068823 -36.785949))', true, 'Open Tenure community area where parcels can be claimed');
INSERT INTO setting (name, vl, active, description) VALUES ('db-utilities-folder', '', true, 'Full path to PostgreSQL utilities (bin) folder (e.g. C:\Program Files\PostgreSQL\9.1\bin). Used for backup/restore implementation of SOLA Web admin application');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-notifiable-submit-body', 'Dear #{notifiablePartyName},<p></p> this is to inform you that one <b>#{actionToNotify}</b> action has been requested 
				<br>by <b>#{targetPartyName}</b> 
				<br>on the following property: <b>#{baUnitName}</b>. <p></p><p></p>Regards,<br />#{sendingOffice}', true, 'Action on Interest body text');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-notifiable-subject', 'SOLA REGISTRY - #{actionToNotify} action on property #{baUnitName}', true, 'Action on Interest subject text');
INSERT INTO setting (name, vl, active, description) VALUES ('command-extract', 'D:\dev\sola\scr\extract-from-admin.bat', true, 'The command for running the extraction.');
INSERT INTO setting (name, vl, active, description) VALUES ('command-consolidate', 'D:\dev\sola\scr\consolidate-from-admin.bat', true, 'The command for running the consolidation.');
INSERT INTO setting (name, vl, active, description) VALUES ('path-to-backup', 'D:\dev\sola\scr\data', true, 'The path of the extracted files.');
INSERT INTO setting (name, vl, active, description) VALUES ('path-to-process-log', 'D:\dev\sola\scr\log', true, 'The path of the process log files.');
INSERT INTO setting (name, vl, active, description) VALUES ('email-mailer-jndi-name', 'mail/sola', true, 'Configured mailer service JNDI name');
INSERT INTO setting (name, vl, active, description) VALUES ('network-scan-folder', '', false, 'Scan folder path, used by digital archive service. This setting is disabled by default. It has to be specified only if specific folder path is required (e.g. network drive). By default, system will use user''s home folder + /sola/scan');
INSERT INTO setting (name, vl, active, description) VALUES ('product-name', 'SOLA Registry', true, 'SOLA product name');
INSERT INTO setting (name, vl, active, description) VALUES ('product-code', 'sr', true, 'SOLA product code. sr - SOLA Registry, ssr - SOLA Systematic Registration, ssl - SOLA State Land, scs - SOLA Community Server');
INSERT INTO setting (name, vl, active, description) VALUES ('moderation_date', '2015-01-01', true, 'Closing date of public display for the claims. Date must be set in the format "yyyy-mm-dd". If date is not set or in the past, "moderation-days" setting will be used for calculating closing date.');
INSERT INTO setting (name, vl, active, description) VALUES ('requires_spatial', '0', true, 'Indicates whether spatial representation of the parcel is required (mandatory). If values is 0, spatial part can be omitted, otherwise validation will request it.');
INSERT INTO setting (name, vl, active, description) VALUES ('report_server_user', 'jasperadmin', true, 'Reporting server user name.');
INSERT INTO setting (name, vl, active, description) VALUES ('report_server_url', 'http://localhost:8080/jasperserver', true, 'Reporting server URL.');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-reg-subject', 'SOLA OpenTenure - registration', true, 'Subject text for new user registration on OpenTenure Web-site. Sent to user.');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-pswd-restore-subject', 'SOLA OpenTenure - password restore', true, 'Password restore subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-submit-subject', 'SOLA OpenTenure - new claim submitted', true, 'New claim subject text');
INSERT INTO setting (name, vl, active, description) VALUES ('reports_folder_url', '/reports/sola', true, 'Folder URL on the reporting server containing reports to display on the menu.');
INSERT INTO setting (name, vl, active, description) VALUES ('report_server_pass', '$olaCommunity2015', true, 'Reporting server user password.');
INSERT INTO setting (name, vl, active, description) VALUES ('map-srid', '32632', true, 'srid for the map');
INSERT INTO setting (name, vl, active, description) VALUES ('map-west', '258697.64', true, 'The most west coordinate. It is used in the map control.');
INSERT INTO setting (name, vl, active, description) VALUES ('map-east', '516039.33', true, 'The most east coordinate. It is used in the map control.');
INSERT INTO setting (name, vl, active, description) VALUES ('map-north', '1478420.54', true, 'The most north coordinate. It is used in the map control.');
INSERT INTO setting (name, vl, active, description) VALUES ('system-id', 'KT', true, 'A unique number that identifies the installed SOLA system. This unique number is used in the br that generate unique identifiers.');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-pswd-restore-body', 'Dear #{userFullName},<br /><br />You have requested to restore the password. If you didn''t ask for this action, just ignore this message. Otherwise, follow <a href="#{passwordRestoreLink}">this link</a> to reset your password.<br /><br />Regards,<br />SOLA OpenTenure Team', true, 'Message text for password restore');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-withdraw-body', 'Dear #{userFirstName},<br /><br />
Claim <a href="#{claimLink}"><b>##{claimNumber}</b></a> has been withdrawn by community recorder.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim withdrawal notice body');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-withdraw-subject', 'SOLA OpenTenure - claim withdrawal', true, 'Claim withdrawal notice subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-submit-body', 'Dear #{userFullName},<br /><br />
New claim <b>##{claimNumber}</b> has been submitted. 
You can follow its status by <a href="#{claimLink}">this address</a>.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'New claim body text');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-reject-subject', 'SOLA OpenTenure - claim rejection', true, 'Claim rejection notice subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-approve-review-body', 'Dear #{userFirstName},<br /><br />
Claim <a href="#{claimLink}"><b>##{claimNumber}</b></a> has passed review stage with success.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim review approval notice body');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-approve-review-subject', 'SOLA OpenTenure - claim review approval', true, 'Claim review approval notice subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-approve-moderation-body', 'Dear #{userFirstName},<br /><br />
Claim <a href="#{claimLink}"><b>##{claimNumber}</b></a> has been approved.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim moderation approval notice body');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-approve-moderation-subject', 'SOLA OpenTenure - claim moderation approval', true, 'Claim moderation approval notice subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-updated-body', 'Dear #{userFullName},<br /><br />Claim <b>##{claimNumber}</b> has been updated. Follow <a href="#{claimLink}">this link</a> to check claim status and updated information.<br /><br />Regards,<br />SOLA OpenTenure Team', true, 'Claim update body text');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-submitted-body', 'Dear #{userFullName},<br /><br />
New claim challenge <a href="#{challengeLink}"><b>##{challengeNumber}</b></a> has been submitted 
to challenge the claim <a href="#{claimLink}"><b>##{claimNumber}</b></a>.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'New claim challenge body text');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-updated-body', 'Dear #{userFullName},<br /><br />
Claim challenge <b>##{challengeNumber}</b> has been updated. 
Follow <a href="#{challengeLink}">this link</a> to check updated information.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim challenge update body text');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-submitted-subject', 'SOLA OpenTenure - new claim challenge to the claim ##{claimNumber}', true, 'New claim challenge subject text');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-updated-subject', 'SOLA OpenTenure - claim challenge ##{challengeNumber} update', true, 'Claim challenge update subject text');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-updated-subject', 'SOLA OpenTenure - claim ##{claimNumber} update', true, 'Claim update subject text');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-approve-review-body', 'Dear #{userFirstName},<br /><br />
Claim challenge <a href="#{challengeLink}"><b>##{challengeNumber}</b></a> has passed review stage.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim challenge review approval notice body');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-approve-review-subject', 'SOLA OpenTenure - claim challenge review', true, 'Claim challenge review approval notice subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-approve-moderation-body', 'Dear #{userFirstName},<br /><br />
Claim challenge <a href="#{challengeLink}"><b>##{challengeNumber}</b></a> has been moderated.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim challenge moderation approval notice body');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-approve-moderation-subj', 'SOLA OpenTenure - claim challenge moderation', true, 'Claim challenge moderation approval notice subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-reject-body', 'Dear #{userFirstName},<br /><br />
Claim <a href="#{claimLink}"><b>##{claimNumber}</b></a> has been rejected with the following reason:<br /><br />
<i>"#{claimRejectionReason}"</i><br /> <br /> 
The following comments were recorded on the claim:<br />#{claimComments}<br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim rejection notice body');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-reject-body', 'Dear #{userFirstName},<br /><br />
Claim challenge <a href="#{challengeLink}"><b>##{challengeNumber}</b></a> has been rejected with the following reason:<br /><br />
<i>"#{challengeRejectionReason}"</i><br /> <br />
Claim challenge comments:<br />#{challengeComments}<br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim challenge rejection notice body');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-reject-subject', 'SOLA OpenTenure - claim challenge rejection', true, 'Claim challenge rejection notice subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-withdraw-body', 'Dear #{userFirstName},<br /><br />
Claim challenge <a href="#{challengeLink}"><b>##{challengeNumber}</b></a> has been withdrawn by community recorder.<br /><br />
<i>You are receiving this notification as the #{partyRole}</i><br /><br />
Regards,<br />SOLA OpenTenure Team', true, 'Claim challenge withdrawal notice body');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-claim-challenge-withdraw-subject', 'SOLA OpenTenure - claim challenge withdrawal', true, 'Claim withdrawal notice subject');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-user-activation-body', 'Dear #{userFullName},<p></p>Your account has been activated. 
<p></p>Please use <b>#{userName}</b> to login.<p></p><p></p>Regards,<br />SOLA OpenTenure Team', true, 'Message text to notify Community member account activation on the Community Server Web-site');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-user-activation-subject', 'SOLA OpenTenure account activation', true, 'Subject text to notify Community member account activation on the Community Server Web-site');
INSERT INTO setting (name, vl, active, description) VALUES ('email-msg-reg-body', 'Dear #{userFullName},<p></p>You have registered on SOLA OpenTenure Web-site. Before you can use your account, it will be reviewed and approved by Community Technologist. 
Upon account approval, you will receive notification message.<p></p>Your user name is<br />#{userName}<p></p><p></p>Regards,<br />SOLA OpenTenure Team', true, 'Message text for new user registration on OpenTenure Web-site. Sent to user.');
INSERT INTO setting (name, vl, active, description) VALUES ('map-south', '1227083.49', true, 'The most south coordinate. It is used in the map control.');
INSERT INTO setting (name, vl, active, description) VALUES ('surveyor', 'TBU SURVEYOR NAME', true, 'Name of Surveyor');
INSERT INTO setting (name, vl, active, description) VALUES ('surveyorRank', 'TBU SURVEYOR RANK', true, 'The rank of the Surveyor');
INSERT INTO setting (name, vl, active, description) VALUES ('state', 'Katsina', true, 'the state');


ALTER TABLE setting ENABLE TRIGGER ALL;

--
-- Data for Name: version; Type: TABLE DATA; Schema: system; Owner: postgres
--

ALTER TABLE version DISABLE TRIGGER ALL;

INSERT INTO version (version_num) VALUES ('1309a');
INSERT INTO version (version_num) VALUES ('1309b');
INSERT INTO version (version_num) VALUES ('1309c');
INSERT INTO version (version_num) VALUES ('1310a');
INSERT INTO version (version_num) VALUES ('1310b');
INSERT INTO version (version_num) VALUES ('1401a');
INSERT INTO version (version_num) VALUES ('1401b');
INSERT INTO version (version_num) VALUES ('1401c');
INSERT INTO version (version_num) VALUES ('1401d');
INSERT INTO version (version_num) VALUES ('1402a');
INSERT INTO version (version_num) VALUES ('1403a');
INSERT INTO version (version_num) VALUES ('1403b');
INSERT INTO version (version_num) VALUES ('1404a');
INSERT INTO version (version_num) VALUES ('1404b');
INSERT INTO version (version_num) VALUES ('1406a');
INSERT INTO version (version_num) VALUES ('1406b');
INSERT INTO version (version_num) VALUES ('1406c');
INSERT INTO version (version_num) VALUES ('1408a');
INSERT INTO version (version_num) VALUES ('1408b');
INSERT INTO version (version_num) VALUES ('1409a');
INSERT INTO version (version_num) VALUES ('1409b');
INSERT INTO version (version_num) VALUES ('1409c');
INSERT INTO version (version_num) VALUES ('1409d');
INSERT INTO version (version_num) VALUES ('1409e');
INSERT INTO version (version_num) VALUES ('1411b');
INSERT INTO version (version_num) VALUES ('1412a');
INSERT INTO version (version_num) VALUES ('1502a');
INSERT INTO version (version_num) VALUES ('1503c');
INSERT INTO version (version_num) VALUES ('1503e');
INSERT INTO version (version_num) VALUES ('1503f');
INSERT INTO version (version_num) VALUES ('1504a');
INSERT INTO version (version_num) VALUES ('1504b');
INSERT INTO version (version_num) VALUES ('1505a');
INSERT INTO version (version_num) VALUES ('1505b');
INSERT INTO version (version_num) VALUES ('1505d');
INSERT INTO version (version_num) VALUES ('1510a');
INSERT INTO version (version_num) VALUES ('1511a');
INSERT INTO version (version_num) VALUES ('1511c');
INSERT INTO version (version_num) VALUES ('1512a');
INSERT INTO version (version_num) VALUES ('1601');
INSERT INTO version (version_num) VALUES ('1603a');
INSERT INTO version (version_num) VALUES ('1603b');
INSERT INTO version (version_num) VALUES ('1604a');
INSERT INTO version (version_num) VALUES ('1604b');
INSERT INTO version (version_num) VALUES ('1604c');
INSERT INTO version (version_num) VALUES ('1604d');
INSERT INTO version (version_num) VALUES ('1604e');
INSERT INTO version (version_num) VALUES ('1607a');


ALTER TABLE version ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

