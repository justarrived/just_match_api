ActiveAdmin.register Job do
  permit_params do
    JobPolicy::FULL_ATTRIBUTES
  end
end
