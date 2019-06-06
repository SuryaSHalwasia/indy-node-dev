from abc import ABCMeta

from common.serializers.serialization import domain_state_serializer
from indy_common.authorize.auth_constraints import ConstraintCreator, ConstraintsSerializer
from indy_common.authorize.auth_request_validator import WriteRequestValidator
from indy_common.constants import CONFIG_LEDGER_ID, AUTH_RULE, CONSTRAINT
from indy_common.state.state_constants import MARKER_AUTH_RULE
from indy_node.server.request_handlers.config_req_handlers.auth_rule.static_auth_rule_helper import StaticAuthRuleHelper
from plenum.common.exceptions import InvalidClientRequest
from plenum.server.database_manager import DatabaseManager
from plenum.server.request_handlers.handler_interfaces.write_request_handler import WriteRequestHandler


class AbstractAuthRuleHandler(WriteRequestHandler, metaclass=ABCMeta):

    def __init__(self, database_manager: DatabaseManager,
                 write_req_validator: WriteRequestValidator):
        super().__init__(database_manager, AUTH_RULE, CONFIG_LEDGER_ID)
        self.write_req_validator = write_req_validator
        self.constraint_serializer = ConstraintsSerializer(domain_state_serializer)

    def _static_validation_for_rule(self, operation, identifier, req_id):
        try:
            ConstraintCreator.create_constraint(operation.get(CONSTRAINT))
        except (ValueError, KeyError) as exp:
            raise InvalidClientRequest(identifier,
                                       req_id,
                                       exp)
        StaticAuthRuleHelper.check_auth_key(operation, identifier, req_id, self.write_req_validator.auth_map)

    def _update_auth_constraint(self, auth_key: str, constraint):
        self.state.set(AbstractAuthRuleHandler.make_state_path_for_auth_rule(auth_key),
                       self.constraint_serializer.serialize(constraint))

    @staticmethod
    def make_state_path_for_auth_rule(action_id) -> bytes:
        return "{MARKER}:{ACTION_ID}" \
            .format(MARKER=MARKER_AUTH_RULE,
                    ACTION_ID=action_id).encode()

