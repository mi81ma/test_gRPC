# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: pancake.proto for package 'pancake.baker'

require 'grpc'
require 'pancake_pb'

module Pancake
  module Baker
    module PancakeBakerService
      class Service

        include GRPC::GenericService

        self.marshal_class_method = :encode
        self.unmarshal_class_method = :decode
        self.service_name = 'pancake.baker.PancakeBakerService'

        # Bakeは指定されたメニューのパンケーキを焼く関数です
        ## rpc :Bake, Pancake::Baker::BakeRequest, Pancake::Baker::BakeResponse
        rpc :Bake, BakeRequest, BakeResponse
        # Reportはメニューごとに焼いたパンケーキの数を返します
        ## rpc :Report, Pancake::Baker::ReportRequest, Pancake::Baker::ReportResponse
        rpc :Report, ReportRequest, ReportResponse
      end

      Stub = Service.rpc_stub_class
    end
  end
end
