# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Book.delete_all
Page.delete_all

b = Book.create( {:title => "Little Red Riding Hood", :image_directory => "little_red_riding_hood"} )

Page.create({:book_id => b.id, 
             :page_num => 1, 
             :page_text => "Once upon a time, there was a little girl who lived in a village near the forest.  Whenever she went out, the little girl wore a red riding cloak, so everyone in the village called her Little Red Riding Hood. \nOne morning, Little Red Riding Hood asked her mother if she could go to visit her grandmother as it had been awhile since they'd seen each other. \n\"That's a good idea,\" her mother said.  So they packed a nice basket for Little Red Riding Hood to take to her grandmother."})
Page.create({:book_id => b.id, 
             :page_num => 2, 
             :page_text => "When the basket was ready, the little girl put on her red cloak and kissed her mother goodbye. \n\"Remember, go straight to Grandma's house,\" her mother cautioned.  \"Don't dawdle along the way and please don't talk to strangers!  The woods are dangerous.\" \n\"Don't worry, mommy,\" said Little Red Riding Hood, \"I'll be careful.\""}) 
Page.create({:book_id => b.id, 
             :page_num => 3, 
             :page_text => "But when Little Red Riding Hood noticed some lovely flowers in the woods, she forgot her promise to her mother.  She picked a few, watched the butterflies flit about for awhile, listened to the frogs croaking and then picked a few more. \nLittle Red Riding Hood was enjoying the warm summer day so much, that she didn't notice a dark shadow approaching out of the forest behind her..."})
Page.create({:book_id => b.id, 
             :page_num => 4, 
             :page_text => "Suddenly, the wolf appeared beside her.\n\"What are you doing out here, little girl?\" the wolf asked in a voice as friendly as he could muster.\n\"I'm on my way to see my Grandma who lives through the forest, near the brook,\"  Little Red Riding Hood replied.\nThen she realized how late she was and quickly excused herself, rushing down the path to her Grandma's house.\nThe wolf, in the meantime, took a shortcut..."})
Page.create({:book_id => b.id, 
             :page_num => 5, 
             :page_text => "The wolf, a little out of breath from running, arrived at Grandma's and knocked lightly at the door.\n\"Oh thank goodness dear!  Come in, come in!  I was worried sick that something had happened to you in the forest,\" said Grandma thinking that the knock was her granddaughter.\nThe wolf let himself in.  Poor Granny did not have time to say another word, before the wolf gobbled her up!"})   
Page.create({:book_id => b.id, 
             :page_num => 6, 
             :page_text => "The wolf let out a satisfied burp, and then poked through Granny's wardrobe to find a nightgown that he liked.  He added a frilly sleeping cap, and for good measure, dabbed some of Granny's perfume behind his pointy ears.\nA few minutes later, Red Riding Hood knocked on the door.  The wolf jumped into bed and pulled the covers over his nose.  \"Who is it?\" he called in a cackly voice.\n\"It's me, Little Red Riding Hood.\"\n\"Oh how lovely!  Do come in, my dear,\" croaked the wolf."}) 
Page.create({:book_id => b.id, 
             :page_num => 7, 
             :page_text => "When Little Red Riding Hood entered the little cottage, she could scarcely recognize her Grandmother.\n\"Grandmother!  Your voice sounds so odd.  Is something the matter?\" she asked.\n\"Oh, I just have touch of a cold,\" squeaked the wolf adding a cough at the end to prove the point."})
Page.create({:book_id => b.id, 
             :page_num => 8, 
             :page_text => "\"But Grandmother!  What big ears you have,\" said Little Red Riding Hood as she edged closer to the bed.\"The better to hear you with, my dear,\" replied the wolf.\n\"But Grandmother!  What big eyes you have,\" said Little Red Riding Hood.\n\"The better to see you with, my dear,\" replied the wolf.\n\"But Grandmother!  What big teeth you have,\" said Little Red Riding Hood her voice quivering slightly.\n\"The better to eat you with, my dear,\" roared the wolf and he leapt out of the bed and began to chase the little girl."})
Page.create({:book_id => b.id, 
             :page_num => 9, 
             :page_text => "Almost too late, Little Red Riding Hood realized that the person in the bed was not her Grandmother, but a hungry wolf.\nShe ran across the room and through the door, shouting, \"Help!  Wolf!\" as loudly as she could.\nA woodsman who was chopping logs nearby heard her cry and ran towards the cottage as fast as he could.\nHe grabbed the wolf and made him spit out the poor Grandmother who was a bit frazzled by the whole experience, but still in one piece."})
Page.create({:book_id => b.id, 
             :page_num => 10, 
             :page_text => "\"Oh Grandma, I was so scared!\"  sobbed Little Red Riding Hood, \"I'll never speak to strangers or dawdle in the forest again.\"\n\"There, there, child.  You've learned an important lesson.  Thank goodness you shouted loud enough for this kind woodsman to hear you!\"\nThe woodsman knocked out the wolf and carried him deep into the forest where he wouldn't bother people any longer.\nLittle Red Riding Hood and her Grandmother had a nice lunch and a long chat."}) 
            
pigs = Book.create( {:title => "Three Little Pigs", :image_directory => "little_red_riding_hood"} )
Page.create({:book_id => pigs.id, 
             :page_num => 1, 
             :page_text => ""})
Page.create({:book_id => pigs.id, 
             :page_num => 2, 
             :page_text => "Once upon a time there was an old pig with three little pigs, and one day she said to them: \"My children, it is time for you to go out in the world and seek your fortunes.\"\nSo, bidding their mother good-bye, the three little pigs set out to earn their living.\nThe first little pig, whose name was Whitey, met a man with a bundle of straw and said to him: \"Please, mister, will you give me that straw to build a house with?\" \nThe man gave Whitey the straw, and he built himself a house with it."})
Page.create({:book_id => pigs.id, 
             :page_num => 3, 
             :page_text => "Presently a wolf came along and knocked at the door of White\'s house.\n \"Little pig, little pig, let me come in!\" he said.\n But, of course, Whitey didn\'t want the wolf to come in, so he said: \"Not by the hair of my chinny-chin-chin!\"\nThis made the wolf angry, and he said:\n\"Then I\'ll huff and I\'ll puff, and I\'ll blow your house in.\"\nSo he huffed and he puffed and he blew the house in. And then he carried poor little Whitey away to his home in the forest.\n"})
Page.create({:book_id => pigs.id, 
             :page_num => 4, 
             :page_text => "The second little pig, whose name was Blackey, met a man carrying some wood, and he said to him, \"Please mister, will you give me that wood to build a house with?\"\nThe man gave Blackey the wood and he built himself a house with it.\nBut along came the wolf and knocked at the door of Blackey\'s house."})
Page.create({:book_id => pigs.id, 
             :page_num => 5, 
             :page_text => "\"Little pig, little pig, let me come in!\" he said.\n\"No, no,\" replied Blackey in great fright. \"Not by the hair on my chinny-chin-chin.\"\n\"Then I\'ll huff and I\'ll puff and I\'ll blow your house in.\"\nSo the wolf huffed and he puffed and at last he blew the house in. And away he went with Blackey to his home in the forest."})
Page.create({:book_id => pigs.id, 
             :page_num => 6, 
             :page_text => "Now the third little pig, whose name was Brownie, met a man with a load of bricks and he said to him: \"Please, mister, will you give me those bricks to build a house with?\"\nThe man gave him the bricks, and Brownie built himself a very snug little house with them.\nHe had just finished his house when the wolf came along.\n\"Little pig, little pig, let me come in!\" he said.\n \"Not by the hair of my chinny-chin-chin!\"\n\"Then I\'ll huff and I\'ll puff and I\'ll blow your house in.\""})
Page.create({:book_id => pigs.id, 
             :page_num => 7, 
             :page_text => "But though the wolf huffed and puffed, and he puffed and he huffed, he could not blow down Brownie\'s house made of bricks. So he said:\"Little pig, I know where there is a nice field of turnips.\"\n\"Where?\" asked Brownie.\n\"Over in Mr. Smith\'s field. If you will be ready tomorrow morning, I will call for you and we will go together to get some for dinner.\"\n\"Very well,\" answered Brownie. \"I will be ready. What time do you want to go?\"\n\"Around six o\'clock,\" answered the wolf."})
Page.create({:book_id => pigs.id, 
             :page_num => 8, 
             :page_text => "Well, do you know, that smart little pig got up at five o\'clock and went out and got the turnips and was back home before the wolf came at six o\'clock. When the wolf found that Brownie had been to Mr Smith\'s field before him, he was very angry, and wondered how he could catch him. So he said: \"Little pig, I know here there is a nice apple orchard.\"\n\"Where?\" asked Brownie.\n\"Down at Merry Garden,\" replied the wolf. \"I will go with you tomorrow morning at five o\'clock and we will get some apples.\"\nBut Brownie hustled and bustled around, and went the next morning at four o\'clock to the apple orchard."})
Page.create({:book_id => pigs.id, 
             :page_num => 9, 
             :page_text => "This time he had farther to go and had to climb the tree, so that just as he was getting down with the apples in a basket, he saw the wolf coming. Of course he was frightened.\nWhen the wolf came up to the tree, he said to Brownie: \"Ah, I see you are here before me. Are they very nice apples?\"\n\"Yes, indeed,\" replied Brownie. \"Here, I will throw one down to you.\" And he threw the apple so far that while the wolf was running to pick it up, the little pig jumped down from the tree and ran home."})
Page.create({:book_id => pigs.id, 
             :page_num => 10, 
             :page_text => "Now the wolf was very, very angry, and he thought and thought and finally thought of a plan to catch the little pig.\nComing to his house the next morning, he said, \"Little pig, there is a fair in town this afternoon. Will you go?\"\n\"Oh yes,\" replied Brownie. \"I will be very glad to go. What time will you want me to be ready?\"\n\"At three o\'clock,\" said the wolf."})
Page.create({:book_id => pigs.id, 
             :page_num => 11, 
             :page_text => "But Brownie went off to the fair at one o\'clock and bought a great big copper kettle. Alas! On the way home with the kettle, he saw the wolf coming up the hill.\nPoor little Brownie. He didn\'t know what to do. And then suddenly he jumped into the copper kettle and gave himself a push. And the kettle went rolling over and over down the hill, with the little pig in it.\nWhen the wolf saw the kettle coming rolling toward him, he was so frightened that he turned and ran back home without going to the fair."})
Page.create({:book_id => pigs.id, 
             :page_num => 12, 
             :page_text => "The next day he stopped at the little pig\'s house and told him how frightened he had been by a great, shining thing that had rolled down the hill toward him.\nThen Brownie laughed and laughed, and said to the wolf: \"Ha! I frightened you, Mister Wolf. I had been to the fair and cought a copper kettle, and when I saw you coming I got into it and rolled down the hill.\"\nThis made the wolf so very angry that he jumped up on to the roof of the little pig\'s house and started to climb down the chimney.\nWhen Brownie saw this, he made a blazing fire in the fireplace and hung the copper kettle over it full of scalding hot water. And just as the wolf came down the chimney, the little pig pulled off the cover of the kettle and plop! into the scalding water fell the wolf."})
Page.create({:book_id => pigs.id, 
             :page_num => 13, 
             :page_text => "So Brownie boiled the wolf for supper and then went out and rescued his two brothers, Whitey and Blackey, from the woods where the wolf had been keeping them.\nAnd they all lived happily ever after in the little brick house together."})