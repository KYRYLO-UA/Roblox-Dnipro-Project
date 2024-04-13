local AdminLevels = {}

AdminLevels[0] = {
     Name = "User",

     ServerLockImmune = false,
}

AdminLevels[1] = {
     Name = "Moder",

     ServerLockImmune = true,
}

AdminLevels[2] = {
     Name = "Admin",

     ServerLockImmune = true,
}

AdminLevels[3] = {
     Name = "Developer",

     ServerLockImmune = true,
}

return AdminLevels
