ActiveAdmin.register User do
  permit_params do
    UserPolicy::SELF_ATTRIBUTES
  end
end
