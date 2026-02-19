resource "aws_iam_group" "education" {
    name = "Education"
    path = "/groups/"
}

resource "aws_iam_group" "engineers" {
    name = "Engineers"
    path = "/groups/"
}
resource "aws_iam_group" "managers" {
    name = "Managers"
    path = "/groups/"
}

resource "aws_iam_group_membership" "education_members" {
    name = "education-group-membership"
    users = [for user in aws_iam_user.user : user.name if user.tags["Department"] == "Education"]
    group = aws_iam_group.education.name
}

resource "aws_iam_group_membership" "engineers_members" {
    name = "engineers-group-membership"
    users = [for user in aws_iam_user.user : user.name if user.tags["Department"] == "Engineering"]
    group = aws_iam_group.engineers.name
}

resource "aws_iam_group_membership" "managers_members" {
    name = "managers-group-membership"
    users = [for user in aws_iam_user.user : user.name if contains(keys(user.tags), "JobTitle") && can(regex("Manager|CEO", user.tags.JobTitle)) ]
    group = aws_iam_group.managers.name
}
