json.extract! transaccionest, :id, :maquinat_id, :tipotransaccion, :cantidad, :status, :created_at, :updated_at
json.url transaccionest_url(transaccionest, format: :json)
