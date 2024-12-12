# app/policies/report_policy.rb
class ReportPolicy < ApplicationPolicy
   def index?
     user.present?
   end
 
   def show?
     user.present?
   end
 
   def create?
     user.admin? || user.contributor?
   end
 
   def update?
     user.admin?
   end
 
   def destroy?
     user.admin?
   end
 end