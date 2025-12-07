        -- Kill Aura (Đã Sửa Lỗi Kick)
        do
            local Enabled
            local AttackCooldown = false -- THÊM: Biến kiểm soát tốc độ tấn công
            local AttackRange = 15 -- Giảm tầm tấn công để an toàn hơn
            
            MainSection:addToggle(
                "Kill Aura",
                nil,
                function(value)
                    Enabled = value
                end
            )
            
            -- Loại bỏ RayCast không cần thiết
            spawnloop(
                function()
                    pcall(
                        function()
                            -- CHỈ chạy khi Enabled, không có cooldown, và không bị TempDisable
                            if Enabled and not AttackCooldown and not TempDisable then
                                
                                for _, Mobs in next, MobHolder do
                                    for Mob, _ in next, Mobs do
                                        local RootPart = IsAlive(Mob) and Mob:FindFirstChild "HumanoidRootPart"
                                        
                                        if RootPart then
                                            local UserPosition = User.Character.PrimaryPart.Position
                                            local MobPosition = RootPart.Position
                                            local distance = (UserPosition - MobPosition).Magnitude
                                            
                                            -- Kiểm tra khoảng cách đơn giản
                                            if distance < AttackRange then
                                                
                                                AttackCooldown = true -- Bật Cooldown: Ngăn tấn công liên tiếp
                                                
                                                -- 1. Triệu hồi vũ khí/Animation
                                                RepStor.ChangeWeld:FireServer("One-Handed Out", "RightLowerArm")
                                                
                                                -- 2. Gửi sự kiện gây sát thương (DamageMob)
                                                game:GetService "ReplicatedStorage".DamageMob:FireServer(
                                                    User.Character.Sword.Middle,
                                                    false,
                                                    Mob.Humanoid
                                                )
                                                
                                                -- 3. Gửi sự kiện PveEnable sau một chút delay ngắn (giả lập)
                                                task.delay(0.05, function()
                                                    game:GetService "ReplicatedStorage".Char.PveEnable:InvokeServer(
                                                        false,
                                                        true,
                                                        User.Character.Sword.Middle,
                                                        Mob,
                                                        2
                                                    )
                                                end)
                                                
                                                -- Reset Cooldown sau 0.4 giây: Thời gian này đủ để giả lập 2-3 đòn đánh/giây
                                                task.delay(0.4, function() 
                                                    AttackCooldown = false 
                                                end)
                                                
                                                return -- Thoát vòng lặp sau khi tấn công mục tiêu đầu tiên
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    )
                end,
                0.1 -- Tăng tốc độ vòng lặp kiểm tra mục tiêu lên 0.1s
            )
        end
