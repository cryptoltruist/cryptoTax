test_that("format_cronos_pos prepare input uses message fallbacks for modern staking txs", {
  data <- data.frame(
    transfer_amount = NA_character_,
    fee.amount = "5584",
    fee.denom = "basecro",
    message_action = "delegate",
    message_auto_claimed_reward_amount = "1846",
    message_auto_claimed_reward_denom = "basecro",
    message_amount = NA_character_,
    message_amount_denom = NA_character_,
    withdraw_rewards_validator = NA_character_,
    delegate_validator = NA_character_,
    message_validator_address = "cro-validator",
    message_module = "staking",
    stringsAsFactors = FALSE
  )

  prepared <- cryptoTax:::.format_cronos_pos_prepare_input(data)

  expect_equal(prepared$quantity, 1846 / 100000000)
  expect_equal(prepared$currency, "CRO")
  expect_equal(prepared$delegate_validator, "cro-validator")
  expect_equal(prepared$withdraw_rewards_validator, "cro-validator")
})

test_that("format_cronos_pos prepare input recovers descriptions when raw logs are empty", {
  data <- data.frame(
    transfer_amount = c(NA_character_, NA_character_, NA_character_),
    fee.amount = c("6038", "9303", "12500"),
    fee.denom = c("basecro", "basecro", "basecro"),
    message_action = c("withdraw_delegator_reward", "delegate", "/cosmos.bank.v1beta1.MsgSend"),
    message_action_raw = c(
      "/cosmos.distribution.v1beta1.MsgWithdrawDelegatorReward",
      "/cosmos.staking.v1beta1.MsgDelegate",
      "/cosmos.bank.v1beta1.MsgSend"
    ),
    message_auto_claimed_reward_amount = c(NA_character_, "1172755", NA_character_),
    message_auto_claimed_reward_denom = c(NA_character_, "basecro", NA_character_),
    message_amount = c("14655199522", "47385486533", "87371253993"),
    message_amount_denom = c("basecro", "basecro", "basecro"),
    withdraw_rewards_validator = c(NA_character_, NA_character_, NA_character_),
    delegate_validator = c(NA_character_, NA_character_, NA_character_),
    message_validator_address = c("cro-validator", "cro-validator", NA_character_),
    message_module = c("error", "error", "error"),
    stringsAsFactors = FALSE
  )

  prepared <- cryptoTax:::.format_cronos_pos_prepare_input(data)

  expect_equal(prepared$description, c("distribution", "staking", "bank"))
  expect_equal(prepared$quantity, c(146.55199522, 0.01172755, 0))
})
