test_that("extract_raw_log parses valid Cronos POS event logs", {
  raw_log <- paste0(
    '[{"msgIndex":0,"events":[',
    '{"type":"message","attributes":',
    '[{"key":"action","value":"delegate","index":false},',
    '{"key":"module","value":"staking","index":false}]},',
    '{"type":"delegate","attributes":',
    '[{"key":"validator","value":"validator-1","index":false}]},',
    '{"type":"transfer","attributes":',
    '[{"key":"sender","value":"cro-sender","index":false},',
    '{"key":"recipient","value":"cro-recipient","index":false},',
    '{"key":"amount","value":"123basecro","index":false}]},',
    '{"type":"ibc_client","attributes":',
    '[{"key":"client_id","value":"07-tendermint-0","index":false}]}',
    ']}]'
  )

  parsed <- cryptoTax:::extract_raw_log(data.frame(log = raw_log))

  expect_s3_class(parsed, "data.frame")
  expect_named(parsed, c(
    "message_action",
    "message_module",
    "transfer_amount",
    "transfer_sender",
    "transfer_recipient",
    "withdraw_rewards_validator",
    "delegate_validator",
    "redelegate_source_validator",
    "unbond_validator",
    "ibc_client_client_id",
    "ibc_client_consensus_heights",
    "log_parse_error"
  ))
  expect_equal(parsed$message_action, "delegate")
  expect_equal(parsed$message_module, "staking")
  expect_equal(parsed$delegate_validator, "validator-1")
  expect_equal(parsed$transfer_sender, "cro-sender")
  expect_equal(parsed$transfer_recipient, "cro-recipient")
  expect_equal(parsed$transfer_amount, "123basecro")
  expect_equal(parsed$ibc_client_client_id, "07-tendermint-0")
})

test_that("extract_raw_log marks failed, empty, and malformed logs as errors", {
  parsed <- cryptoTax:::extract_raw_log(data.frame(log = c(
    "failed to execute message",
    "",
    "{\"events\":"
  )))

  expect_equal(parsed$message_action, rep("error", 3))
  expect_equal(parsed$message_module, rep("error", 3))
  expect_equal(parsed$log_parse_error[[1]], NA_character_)
  expect_match(parsed$log_parse_error[[2]], "empty raw log")
  expect_match(parsed$log_parse_error[[3]], "parse error|premature EOF")
})

test_that("normalize_cronos_message_action maps protobuf names to legacy action names", {
  expect_equal(
    cryptoTax:::normalize_cronos_message_action(c(
      "/cosmos.staking.v1beta1.MsgDelegate",
      "/cosmos.staking.v1beta1.MsgUndelegate",
      "/cosmos.staking.v1beta1.MsgBeginRedelegate",
      "/cosmos.distribution.v1beta1.MsgWithdrawDelegatorReward",
      "/cosmos.bank.v1beta1.MsgSend"
    )),
    c(
      "delegate",
      "begin_unbonding",
      "begin_redelegate",
      "withdraw_delegator_reward",
      "/cosmos.bank.v1beta1.MsgSend"
    )
  )
})

test_that("extract_cronos_message_fields captures message payload fallbacks", {
  results <- list(list(
    messages = list(list(
      type = "/cosmos.staking.v1beta1.MsgDelegate",
      content = list(
        amount = list(denom = "basecro", amount = "123000000"),
        autoClaimedRewards = list(denom = "basecro", amount = "4567"),
        validatorAddress = "cro-val",
        recipientAddress = "cro-recipient"
      )
    ))
  ))

  parsed <- cryptoTax:::extract_cronos_message_fields(results)

  expect_equal(parsed$message_action_raw, "/cosmos.staking.v1beta1.MsgDelegate")
  expect_equal(parsed$message_amount, "123000000")
  expect_equal(parsed$message_amount_denom, "basecro")
  expect_equal(parsed$message_auto_claimed_reward_amount, "4567")
  expect_equal(parsed$message_auto_claimed_reward_denom, "basecro")
  expect_equal(parsed$message_validator_address, "cro-val")
  expect_equal(parsed$message_recipient_address, "cro-recipient")
})
