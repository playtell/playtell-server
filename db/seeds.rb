# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Book.delete_all
Page.delete_all
=begin
t = Book.create( {:title => "James and the Red Balloon", :image_directory => "james-and-the-red-balloon"} )
Page.create({:book_id => t.id,
             :page_num => 1,
             :page_text => "It is summer holiday time on the Island of Sodor. Vacationers come from far and wide to
             enjoy the beauty of the island. It is the busiest time of the year for Sir Topham Hatt\'s engines.
             Thomas was excited. Sir Topham Hatt had sent him to pick up a special delivery to Dryaw
             Airfield."})
Page.create({:book_id => t.id,
             :page_num => 2,
             :page_text => "\"What have you got there?\" tooted Percy. \"A balloon,\" replied Thomas. \"A party             balloon?\" asked Percy excitedly. \"No,\" said Thomas. \"This is a very special balloon.\" And he chuffed away."})
Page.create({ :book_id => t.id,
              :page_num => 3,
              :page_text => "Soon Thomas arrived at the airfield. And hot air was puffed into the balloon.\n\"What is that?\" huffed James. \"A hot-air balloon,\" said Thomas. \"It will take vacationers on rides around the island!\""})
Page.create({ :book_id => t.id,
              :page_num => 4,
              :page_text => "\"Taking vacationers on rides around the island is our job,\" wheeshed James jealously. Then, as if by magic, the hot-air balloon rose silently up into the sky. \"What if the hot-air balloon takes our passengers away?\" chuffed James. \"What will happen to us then?\""})             
Page.create({ :book_id => t.id,
              :page_num => 5,
              :page_text => "This made Thomas worry. Suddenly he wasn\'t so excited about the balloon. The balloon could be seen by everyone on the Island of Sodor. Duck gazed at it for so long, he ran into the back of Stepney. \"Why, it\'s a floating basket with folks in it,\" said Donald. \"Whatever will they dream up next?\" said Douglas."})
Page.create({ :book_id => t.id,
              :page_num => 6,
              :page_text => "James and Thomas were waiting at the level crossing. They were still worried about the hot-air balloon. \"If it takes our passengers away,\" chuffed Thomas, \"there\'ll be no use for us engines.\" \"Passengers should travel on trains!\" huffed James. \"Not in silly balloons.\""})
Page.create({ :book_id => t.id,
              :page_num => 7,
              :page_text => "Then something big and round and red drifted straight towards them. \"We\'re out of hot air!\" shouted a voice.\n\"ARRRRGGGGGGGHHHHH!\" Cried James. \"What\'s happening?\" Crash! Bang! Wallop! Went the balloon, and landed right on top of James. He was so scared he let out a huge burst of steam, which blew the balloon up again."})                            
              Page.create({ :book_id => t.id,
              :page_num => 8,
              :page_text => "The balloon rose into the air once more. \"Well done, James!\" called his driver. \"Your hot air did the trick.\" \"Oh, no James!\" cried Thomas. \"You saved the hot-air balloon!\""})                            
Page.create({ :book_id => t.id,
              :page_num => 9,
              :page_text => "\"I didn\'t mean to!\" groaned James. \"Now it\'s sure to take our passengers.\" Wherever James went, he could see the balloon carrying vacationers across the island. He felt he should be taking those passengers. \"Rails are better than hot air any day.\""})                            
Page.create({ :book_id => t.id,
              :page_num => 10,
              :page_text => "James arrived back at the station. There were lots of people on the platform. Sir Topham Hatt was waiting, too. \"Well done, James!\" \n\"But now the passengers will ride the hot-air balloon.\""})
Page.create({ :book_id => t.id,
              :page_num => 11,
              :page_text => "Sir Topham Hatt laughed. \"You\'re right, James\" he said. \"but they will need a ride home - in a train!\" James was delighted."})
Page.create({ :book_id => t.id,
              :page_num => 12,
              :page_text => "Sir Topham Hatt was right. The engines were busier than ever taking vacationers to and from the airfield."})                                                        
Page.create({ :book_id => t.id,
              :page_num => 13,
              :page_text => "Whenever James sees the red balloon, he whistles and toots. And sometimes, when he\'s asleep at night, James dreams he can fly too..."})
Page.create({ :book_id => t.id,
              :page_num => 14,
              :page_text => "...Just like the red balloon!"})
=end

b = Book.create( {:title => "Koda's Adventure", :image_directory => "kodas-adventure", :image_only => 1} )
Page.create({:book_id => b.id, 
             :page_num => 1, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 2, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 3, 
             :page_text => ""})

=begin
b = Book.create( {:title => "Barry the Barred Owl", :image_directory => "barry-the-owl", :image_only => 1} )             
Page.create({:book_id => b.id, 
            :page_num => 1, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 2, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 3, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 4, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 5, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 6, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 7, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 8, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 9, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 10, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 11, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 12, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 13, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 14, 
            :page_text => ""})
Page.create({:book_id => b.id, 
            :page_num => 15, 
            :page_text => ""})
=end
                                                                                      
b = Book.create({ :title => "Little Red Riding Hood", :image_directory => "little-red-riding-hood" })
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
                         :page_text => "When Little Red Riding Hood entered the little cottage, she could scarcely recognize her Grandmother.\n\"Grandmother!  Your voice sounds so odd.  Is something the matter?\" she asked.\n\"Oh, I just have touch of a cold,\" squeaked the wolf adding a cough at the end to prove the point.\n\"But Grandmother!  What big ears you have,\" said Little Red Riding Hood as she edged closer to the bed.\"The better to hear you with, my dear,\" replied the wolf."})
Page.create({:book_id => b.id, 
                         :page_num => 8, 
                         :page_text => "\"But Grandmother!  What big eyes you have,\" said Little Red Riding Hood.\n\"The better to see you with, my dear,\" replied the wolf.\n\"But Grandmother!  What big teeth you have,\" said Little Red Riding Hood her voice quivering slightly.\n\"The better to eat you with, my dear,\" roared the wolf and he leapt out of the bed and began to chase the little girl."})
Page.create({:book_id => b.id, 
                         :page_num => 9, 
                         :page_text => "Almost too late, Little Red Riding Hood realized that the person in the bed was not her Grandmother, but a hungry wolf.\nShe ran across the room and through the door, shouting, \"Help!  Wolf!\" as loudly as she could.\nA woodsman who was chopping logs nearby heard her cry and ran towards the cottage as fast as he could.\nHe grabbed the wolf and made him spit out the poor Grandmother who was a bit frazzled by the whole experience, but still in one piece."})
Page.create({:book_id => b.id, 
                         :page_num => 10, 
                         :page_text => "\"Oh Grandma, I was so scared!\"  sobbed Little Red Riding Hood, \"I'll never speak to strangers or dawdle in the forest again.\"\n\"There, there, child.  You've learned an important lesson.  Thank goodness you shouted loud enough for this kind woodsman to hear you!\"\nThe woodsman knocked out the wolf and carried him deep into the forest where he wouldn't bother people any longer.\nLittle Red Riding Hood and her Grandmother had a nice lunch and a long chat."}) 

 b = Book.create( {:title => "Monday's Child", :image_directory => "Mondays-Child", :image_only => 1} )

 Page.create({:book_id => b.id, 
              :page_num => 1, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 2, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 3, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 4, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 5, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 6, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 7, 
              :page_text => ""})


 b = Book.create( {:title => "This Old Man", :image_directory => "this-old-man", :image_only => 1} )

 Page.create({:book_id => b.id, 
              :page_num => 1, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 2, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 3, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 4, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 5, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 6, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 7, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 8, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 9, 
              :page_text => ""})
 Page.create({:book_id => b.id, 
              :page_num => 10, 
              :page_text => ""})

t = Book.create( {:title => "Thomas Breaks a Promise", :image_directory => "thomas-breaks-a-promise"} )
Page.create({:book_id => t.id, 
            :page_num => 1, 
            :page_text => ""})
Page.create({:book_id => t.id, 
           :page_num => 2, 
           :page_text => "The seasons were changing on the Island of Sodor. The leaves had begun to change color, and the air was growing crisp. Thomas the Tank Engine was feeling restless.\n\"Summer is almost over, and I haven\'t had any real fun,\" he complained. \n\"You\'re a fussy little engine,\" replied Gordon. \"We\'re not here to have fun. We\'re here to work.\"\nWell, that didn\'t make Thomas feel any better.\n\"I\'d rather be fussy and fun than bossy and boring!\" he retorted."
           })
Page.create({:book_id => t.id, 
            :page_num => 3, 
            :page_text => "The next morning, Sir Topham Hatt called the engines together.\n\"We\'re opening a new branch line tomorrow,\" he told them. \"I need one of you to check the signals on the new line to see that they\'re all working properly. Who will volunteer?\""
            })
Page.create({:book_id => t.id, 
           :page_num => 4, 
           :page_text => "\"I will,\" Thomas piped up. \"I promise to check very carefully.\" Checking signals wasn\'t much fun, but it was better than being bossed around in the train yard.\n\"Off you go, then,\" said Sir Topham Hatt. \"And be sure to check every signal, Thomas. Safety is our first concern.\""
           })
Page.create({:book_id => t.id, 
            :page_num => 5, 
            :page_text => "Something about shiny new tracks always put Thomas in a good mood. He whistled merrily as he rolled along the new branch line. \"Checking signals is really useful,\" he thought. \"Safety is our first concern.\""
            })
Page.create({:book_id => t.id, 
           :page_num => 6, 
           :page_text => "Each time he saw a signal, Thomas made sure that the arm was in the right position. He also checked to see that the signal lamp was working, so it could be seen at night.\nIf the signal arm was down and the lamp was red, that meant danger on the tracks ahead.\nThere were hidden junctions..."
           })
Page.create({:book_id => t.id, 
            :page_num => 7, 
            :page_text => "...hanging rocks..."
            })
Page.create({:book_id => t.id, 
           :page_num => 8, 
           :page_text => "...dangerous curves..."
           })
Page.create({:book_id => t.id, 
            :page_num => 9, 
            :page_text => "...and steep hills..."})
Page.create({:book_id => t.id, 
          :page_num => 10, 
          :page_text => "Thomas had almost reached the end of the new branch line when he saw the sign for a carnival. there was nothing Thomas loved more than a carnival. Oh, how he would love to go!"
          })
Page.create({:book_id => t.id, 
           :page_num => 11, 
           :page_text => "\"If I hurry to the carnival now, I can check the rest of the signals later,\" he told himself. And with that, Thomas turned off and headed into the countryside."
           })
Page.create({:book_id => t.id, 
          :page_num => 12, 
          :page_text => "The carnival was splendid. There were games and rides and cotton candy. And there were lots of children.\n\"Look, it\'s Thomas!\" they cried, and ran to greet their favorite blue engine."
          })
Page.create({:book_id => t.id, 
           :page_num => 13, 
           :page_text => "When Thomas got back to the train yard, Sir Topham Hatt was waiting.\n\"You've been gone a long time, Thomas,\" he said. \"You must have done a very thorough job of checking the signals on the new branch line.\""
           })
Page.create({:book_id => t.id, 
          :page_num => 14, 
          :page_text => "\"Yes sir,\" peeped Thomas. But suddenly he realized that he\'d forgotten to go back and finish the job. He had broken his promise! But how could he tell that to Sir Topham Hatt?\n\"Good.\" Sir Topham Hatt beamed. \"Then everything is ready for tomorrow\'s grand opening.\""
          })
Page.create({:book_id => t.id, 
           :page_num => 15, 
           :page_text => "Thomas gulped. What if there was trouble? What if one of the unchecked signals didn\'t work?\n\"I know,\" thought Thomas. \"I\'ll get up very early tomorrow and go out to check the rest of the signals before the grand opening.\""
           })
Page.create({:book_id => t.id, 
          :page_num => 16, 
          :page_text => "That night, Percy was being loaded for his mail run when a call came into the station. Rain had washed out a section of track on the mail route. Percy would have to find a way around."
          })
Page.create({:book_id => t.id, 
           :page_num => 17, 
           :page_text => "\"Don\'t worry, Percy.\" Sir Toham Hatt smiled. \"You can take the new branch line.\"\nOff Percy went, pulling two big cars loaded with mail."
           })
Page.create({:book_id => t.id, 
          :page_num => 18, 
          :page_text => "The rain fell heavily. Each time Percy saw a red signal lamp, he slowed carefully until he had passed the dangerous spot. Then suddenly, in the dark, Percy passed another signal. The lamp was not lit, so he didn\'t see it until it was too late. The arm was down, for danger!"
          })
Page.create({:book_id => t.id, 
           :page_num => 19, 
           :page_text => "Percy slammed on his brakes, but the rain made the tracks slippery. And there it was ahead -- a very dangerous curve.\n\"Oh, no!\" cried Percy. He closed his eyes and did his best to hold on through the turn.\nCRASH! One of the mail cars flew off the tracks and was smashed to bits. Percy shivered with fear from his close call."
           })
Page.create({:book_id => t.id, 
          :page_num => 20, 
          :page_text => "The next morning, Thomas awoke and sneaked out of his shed. Then he saw Percy returning with Sir Topham Hatt.\n\"Percy has had a terrible fright,\" Sir Topham said sternly. \"He almost derailed because of a signal lamp that didn\'t work. How could such a thing have happened, Thomas?\""
          })
Page.create({:book_id => t.id, 
           :page_num => 21, 
           :page_text => "\"Oh sir! I\'m so sorry, sir,\" Thomas sputtered. And it all came rushing out -- about the carnival, and the children, and about how he\'d forgotten to go back and finish the job.\n\"I\'m sorry I broke my promise, sir,\" said Thomas sheepishly. \"I just wanted to be part of the fun, and then I forgot.\""
           })
Page.create({:book_id => t.id, 
          :page_num => 22, 
          :page_text => "\"There will be no fun for you for quite some time,\" Sir Topham Hatt scolded. \"Percy will run your branch line until you\'ve gone and checked every signal on my railway -- twice!\""
          })
Page.create({:book_id => t.id, 
           :page_num => 23, 
           :page_text => "And now, every time Thomas passes a signal, he checks it twice, just to be safe. Gordon likes to tease him. \"Fussy little Thomas certainly is fussy about signals.\"\n\"Peep, peep!\" says Thomas. \"Safety is our first concern.\""
           })
