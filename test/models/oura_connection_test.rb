# == Schema Information
#
# Table name: oura_connections
#
#  id            :bigint           not null, primary key
#  access_token  :text
#  expires_at    :datetime
#  refresh_token :text
#  scope         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_oura_connections_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class OuraConnectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
