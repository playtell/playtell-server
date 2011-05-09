# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.delete_all
User.create( { :username => 'srahemtulla', :tokbox_session_id => '28ee9c84a651a59fe5caf313fcad80971e136e77'} )

Book.delete_all
b = Book.create( {:title => "Little Red Riding Hood", :image_directory => "little_red_riding_hood"} )

Page.delete_all
Page.create({:book_id => b.id, 
             :page_num => 1, 
             :page_text => "Once upon a time, there was a little girl who lived in a village near the forest.  Whenever she went out, the little girl wore a red riding cloak, so everyone in the village called her Little Red Riding Hood. One morning, Little Red Riding Hood asked her mother if she could go to visit her grandmother as it had been awhile since they'd seen each other. \"That's a good idea,\" her mother said.  So they packed a nice basket for Little Red Riding Hood to take to her grandmother."})
Page.create({:book_id => b.id, 
             :page_num => 2, 
             :page_text => "When the basket was ready, the little girl put on her red cloak and kissed her mother goodbye. \"Remember, go straight to Grandma's house,\" her mother cautioned.  \"Don't dawdle along the way and please don't talk to strangers!  The woods are dangerous.\" \"Don't worry, mommy,\" said Little Red Riding Hood, \"I'll be careful.\""}) 
Page.create({:book_id => b.id, 
             :page_num => 3, 
             :page_text => "But when Little Red Riding Hood noticed some lovely flowers in the woods, she forgot her promise to her mother.  She picked a few, watched the butterflies flit about for awhile, listened to the frogs croaking and then picked a few more. Little Red Riding Hood was enjoying the warm summer day so much, that she didn't notice a dark shadow approaching out of the forest behind her..."})
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
            