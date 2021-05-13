FactoryGirl.define do
  factory :peer_evaluation do
    team nil
    adviser nil
    submission nil
    public_content '{q[1][1]: 5}'
    private_content '{q[5][1]: 5}'
    owner_type 0
  end
end
