defmodule Rpc.Data do

  def insert(collection, document) do
    Mongo.insert_one(:mongo, collection, document, pool: DBConnection.Poolboy)
  end

  def find(collection, document_id) when is_binary(document_id) do
    find(collection, %{_id: document_id})
  end
  def find(collection, document) do
    Mongo.find_one(:mongo, collection, document, pool: DBConnection.Poolboy)
  end

  def clean(collection) do
    Mongo.delete_many(:mongo, collection, %{}, pool: DBConnection.Poolboy)
  end

  def delete(collection, document_id) when is_binary(document_id) do
    delete(collection, %{_id: document_id})
  end
  def delete(collection, document) do
    Mongo.find_one_and_delete(:mongo, collection, document, pool: DBConnection.Poolboy)
  end

end