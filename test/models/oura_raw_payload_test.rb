# == Schema Information
#
# Table name: oura_raw_payloads
#
#  id         :bigint           not null, primary key
#  data_type  :string           not null
#  end_date   :date             not null
#  payload    :jsonb            not null
#  start_date :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_oura_raw_payloads_on_user_id  (user_id)
#  index_oura_raw_range                (user_id,data_type,start_date,end_date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class OuraRawPayloadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
