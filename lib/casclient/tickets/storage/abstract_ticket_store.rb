module CASClient
  module Tickets
    module Storage
      class AbstractTicketStore
        attr_accessor :log
        
        def log
          @log ||= CASClient::LoggerWrapper.new
        end

        def process_single_sign_out(st)
          session_id, session = get_session_for_service_ticket(st)
          if session
            session.destroy
            log.debug("Destroyed #{session.inspect} for session #{session_id.inspect} corresponding to service ticket #{st.inspect}.")
          else
            log.debug("Data for session #{session_id.inspect} was not found. It may have already been cleared by a local CAS logout request.")
          end

          if session_id
            log.info("Single-sign-out for service ticket #{session_id.inspect} completed successfuly.")
          else
            log.debug("No session id found for CAS ticket #{st}")
          end
        end

        def store_service_session_lookup(st, controller)
          raise NotImplementedError
        end

        def cleanup_service_session_lookup(st)
          raise NotImplementedError
        end

        def save_pgt_iou(pgt_iou, pgt)
          raise NotImplementedError
        end

        def retrieve_pgt(pgt_iou)
          raise NotImplementedError
        end

      protected
        def read_service_session_lookup(st)
          raise NotImplementedError
        end

        def session_id_from_controller(controller)
          session_id = controller.request.session_options[:id] || controller.session.session_id
          raise CASClient::CASException, "Failed to extract session_id from controller" if session_id.nil?
          session_id
        end
      end
    end
  end
end