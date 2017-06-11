defmodule Mix.Tasks.Rpc.Generate do
  @shortdoc "Consumes webservice, resize images and populate db"

  def run do
    Rpc.Tasks.Consume.generate_image_list
  end
end