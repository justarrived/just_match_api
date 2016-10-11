ActiveAdmin.register User do
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  permit_params do
    extras = [:password, :language_id, :company_id]
    UserPolicy::SELF_ATTRIBUTES + extras
  end
end
