class Task < ApplicationRecord
  belongs_to :user

  #Será enum para mapear int->str {No banco salva 0,1,2 que no codigo vira -> task.easy?, task.medium?, tanks;hard?}
  enum difficulty: { easy: 0, medium: 1, hard: 2 }

  #algumas validações
  validates :title, presence: true
  validates :difficulty, presence: true

  def score_points
    case difficulty
    when 'easy' then 10
    when 'medium' then 30
    when 'hard' then 50
    else 0
    end
  end

  def mark_as_incomplete!
    update!(completed: false)
  end

end
