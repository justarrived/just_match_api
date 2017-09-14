# frozen_string_literal: true

class CreateJobDigestService
  def self.call(
      job_digest_params:,
      addresses_params:,
      occupation_ids_param:,
      current_user: User.new,
      uuid: nil,
      user_id: nil,
      email: nil
  )
    job_digest = JobDigest.new(job_digest_params)
    job_digest.subscriber = if uuid.present?
                              DigestSubscriber.find_by(uuid: uuid)
                            else
                              CreateDigestSubscriberService.call(
                                current_user: current_user,
                                user_id: user_id,
                                email: email
                              )
                            end

    job_digest.addresses = addresses_params.map { |params| Address.new(params) }

    if job_digest.save
      job_digest.occupations = Occupation.where(id: occupation_ids_param)
      DigestCreatedNotifier.call(job_digest: job_digest)
    end
    job_digest
  end
end
