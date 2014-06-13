//
//  MaterialTypeVC.m
//  Plenary1
//
//  Created by Eric Ito on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MaterialTypeVC.h"


@implementation MaterialTypeVC

@synthesize tableView;// = _tableView;
@synthesize materials;// = _materials;
@synthesize currentMaterial;// = _currentMaterial;
@synthesize delegate;// = _delegate;
@synthesize didSelectMaterial;// = _didSelectMaterial;
@synthesize didCancelSelectMaterial;// = _didCancelSelectMaterial;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (id)initWithNibName:(NSString *)nibNameOrNil material:(NSString*)material {
	if (self = [self initWithNibName:nibNameOrNil bundle:nil]) {
		self.currentMaterial = material;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.materials = [NSArray arrayWithObjects:
//					  @"Ammonia, anhydrous", 
//					  @"Anhydrous ammonia", 
//					  @"Boron trifluoride", 
//					  @"Boron trifluoride, compressed", 
//					  @"Carbon monoxide", 
//					  @"Carbon monoxide, compressed", 
//					  @"Chlorine", 
//					  @"Coal gas", 
//					  @"Coal gas, compressed", 
//					  @"Cyanogen", 
//					  @"Cyanogen gas", 
//					  @"Ethylene oxide", 
//					  @"Ethylene oxide with Nitrogen", 
//					  @"Fluorine", 
//					  @"Fluorine, compressed", 
//					  @"Hydrogen bromide, anhydrous", 
//					  @"Hydrogen chloride, anhydrous", 
//					  @"AC (when used as a weapon)", 
//					  @"Hydrogen cyanide, anhydrous, stabilized", 
//					  @"Hydrogen cyanide, stabilized", 
//					  @"Hydrogen fluoride, anhydrous", 
//					  @"Hydrogen sulfide", 
//					  @"Hydrogen sulphide", 
//					  @"Methyl bromide", 
//					  @"Methyl mercaptan", 
//					  @"Dinitrogen tetroxide", 
//					  @"Nitrogen dioxide", 
//					  @"Nitrosyl chloride", 
//					  @"Oil gas", 
//					  @"Oil gas, compressed", 
//					  @"CG (when used as a weapon)", 
//					  @"Diphosgene", 
//					  @"DP (when used as a weapon)", 
//					  @"Phosgene", 
//					  @"Sulfur dioxide", 
//					  @"Sulphur dioxide", 
//					  @"Trifluorochloroethylene, stabilized", 
//					  @"Acrolein, stabilized", 
//					  @"Allyl alcohol", 
//					  @"Ethylene chlorohydrin", 
//					  @"Crotonaldehyde", 
//					  @"Crotonaldehyde, stabilized", 
//					  @"Dimethyldichlorosilane (when spilled in water)", 
//					  @"1,1-Dimethylhydrazine", 
//					  @"Dimethylhydrazine, unsymmetrical", 
//					  @"Ethyl chloroformate", 
//					  @"Ethyldichlorosilane (when spilled in water)", 
//					  @"Ethyleneimine, stabilized", 
//					  @"Ethyltrichlorosilane (when spilled in water)", 
//					  @"Methyl chloroformate", 
//					  @"Methyl chloromethyl ether", 
//					  @"Methyldichlorosilane (when spilled in water)", 
//					  @"Methylhydrazine", 
//					  @"Methyltrichlorosilane (when spilled in water)", 
//					  @"Methyl vinyl ketone, stabilized", 
//					  @"Nickel carbonyl", 
//					  @"Trichlorosilane (when spilled in water)", 
//					  @"Pentaborane", 
//					  @"Tetranitromethane", 
//					  @"MD (when used as a weapon)", 
//					  @"Methyldichloroarsine", 
//					  @"PD (when used as a weapon)", 
//					  @"Arsenic chloride", 
//					  @"Arsenic trichloride", 
//					  @"Bromoacetone", 
//					  @"Chloropicrin", 
//					  @"Chloropicrin and Methyl bromide mixture", 
//					  @"Methyl bromide and Chloropicrin mixture", 
//					  @"Chloropicrin and Methyl chloride mixture", 
//					  @"Methyl chloride and Chloropicrin mixture", 
//					  @"Chloropicrin mixture, n.o.s.", 
//					  @"CK (when used as a weapon)", 
//					  @"Cyanogen chloride, stabilized", 
//					  @"Dimethyl sulfate", 
//					  @"Dimethyl sulphate", 
//					  @"Ethylene dibromide", 
//					  @"Nitric oxide", 
//					  @"Nitric oxide, compressed", 
//					  @"Perchloromethyl mercaptan", 
//					  @"Potassium cyanide (when spilled in water)", 
//					  @"Potassium cyanide, solid (when spilled in water)", 
//					  @"Sodium cyanide (when spilled in water)", 
//					  @"Sodium cyanide, solid (when spilled in water)", 
//					  @"CA (when used as a weapon)", 
//					  @"Chloroacetone, stabilized", 
//					  @"CN (when used as a weapon)", 
//					  @"Adamsite (when used as a weapon)", 
//					  @"DM (when used as a weapon)", 
//					  @"DA (when used as a weapon)", 
//					  @"Acetyl bromide (when spilled in water)", 
//					  @"Acetyl chloride (when spilled in water)", 
//					  @"Allyl chlorocarbonate", 
//					  @"Allyl chloroformate", 
//					  @"Amyltrichlorosilane (when spilled in water)", 
//					  @"Antimony pentafluoride (when spilled in water)", 
//					  @"Boron trichloride (when spilled on land)", 
//					  @"Boron trichloride (when spilled in water)", 
//					  @"Bromine", 
//					  @"Bromine, solution", 
//					  @"Propionyl chloride (when spilled in water)", 
//					  @"Propyltrichlorosilane (when spilled in water)", 
//					  @"Silicon tetrachloride (when spilled in water)", 
//					  @"Sulfur chlorides (when spilled on land)", 
//					  @"Sulfur chlorides (when spilled in water)", 
//					  @"Sulphur chlorides (when spilled on land)", 
//					  @"Sulphur chlorides (when spilled in water)", 
//					  @"Sulfur trioxide, inhibited", 
//					  @"Sulfur trioxide, stabilized", 
//					  @"Sulfur trioxide, uninhibited", 
//					  @"Sulphur trioxide, inhibited", 
//					  @"Sulphur trioxide, stabilized", 
//					  @"Sulphur trioxide, uninhibited", 
//					  @"Sulfuric acid, fuming", 
//					  @"Sulfuryl chloride (when spilled on land)", 
//					  @"Sulfuryl chloride (when spilled in water)", 
//					  @"Sulphuryl chloride (when spilled on land)", 
//					  @"Sulphuryl chloride (when spilled in water)", 
//					  @"Thionyl chloride (when spilled on land)", 
//					  @"Thionyl chloride (when spilled in water)", 
//					  @"Titanium tetrachloride (when spilled on land)", 
//					  @"Titanium tetrachloride (when spilled in water)", 
//					  @"Silicon tetrafluoride", 
//					  @"Silicon tetrafluoride, compressed", 
//					  @"ED (when used as a weapon)", 
//					  @"Ethyldichloroarsine", 
//					  @"Acetyl iodide (when spilled in water)", 
//					  @"Diborane", 
//					  @"Diborane, compressed", 
//					  @"Calcium dithionite (when spilled in water)", 
//					  @"Calcium hydrosulfite (when spilled in water)", 
//					  @"Calcium hydrosulphite (when spilled in water)", 
//					  @"Potassium dithionite (when spilled in water)", 
//					  @"Potassium hydrosulfite (when spilled in water)", 
//					  @"Potassium hydrosulphite (when spilled in water)", 
//					  @"Zinc dithionite (when spilled in water)", 
//					  @"Zinc hydrosulfite (when spilled in water)", 
//					  @"Zinc hydrosulphite (when spilled in water)", 
//					  @"Insecticide gas, poisonous, n.o.s.", 
//					  @"Insecticide gas, toxic, n.o.s.", 
//					  @"Parathion and compressed gas mixture", 
//					  @"Dinitrogen tetroxide and Nitric oxide mixture", 
//					  @"Nitric oxide and Dinitrogen tetroxide mixture", 
//					  @"Nitric oxide and Nitrogen dioxide mixture", 
//					  @"Nitric oxide and Nitrogen tetroxide mixture", 
//					  @"Nitrogen dioxide and Nitric oxide mixture", 
//					  @"Nitrogen tetroxide and Nitric oxide mixture", 
//					  @"Iron pentacarbonyl", 
//					  @"Magnesium diamide (when spilled in water)", 
//					  @"Magnesium phosphide (when spilled in water)", 
//					  @"Potassium phosphide (when spilled in water)", 
//					  @"Strontium phosphide (when spilled in water)", 
//					  @"Nitric acid, fuming", 
//					  @"Nitric acid, red fuming", 
//					  @"Hydrogen chloride, refrigerated liquid", 
//					  @"Arsine", 
//					  @"SA (when used as a weapon)", 
//					  @"Dichlorosilane", 
//					  @"Oxygen difluoride", 
//					  @"Oxygen difluoride, compressed", 
//					  @"Sulfuryl fluoride", 
//					  @"Sulphuryl fluoride", 
//					  @"Germane", 
//					  @"Selenium hexafluoride", 
//					  @"Tellurium hexafluoride", 
//					  @"Tungsten hexafluoride", 
//					  @"Hydrogen iodide, anhydrous", 
//					  @"Phosphorus pentafluoride", 
//					  @"Phosphorus pentafluoride, compressed", 
//					  @"Phosphine", 
//					  @"Hydrogen selenide, anhydrous", 
//					  @"Carbonyl sulfide", 
//					  @"Carbonyl sulphide", 
//					  @"Chloroacetaldehyde", 
//					  @"2-Chloroethanal", 
//					  @"Allylamine", 
//					  @"Phenyl mercaptan", 
//					  @"Butyryl chloride (when spilled in water)", 
//					  @"1,2-Dimethylhydrazine", 
//					  @"Dimethylhydrazine, symmetrical", 
//					  @"Isobutyryl chloride (when spilled in water)", 
//					  @"Isopropyl chloroformate", 
//					  @"Carbonyl fluoride", 
//					  @"Carbonyl fluoride, compressed", 
//					  @"Sulfur tetrafluoride", 
//					  @"Sulphur tetrafluoride", 
//					  @"Hexafluoroacetone", 
//					  @"Nitrogen trioxide", 
//					  @"Trimethylacetyl chloride", 
//					  @"Trichloroacetyl chloride", 
//					  @"Thiophosgene", 
//					  @"Methyl isothiocyanate", 
//					  @"Methyl isocyanate", 
//					  @"Ethyl isocyanate", 
//					  @"n-Propyl isocyanate", 
//					  @"Isopropyl isocyanate", 
//					  @"tert-Butyl isocyanate", 
//					  @"n-Butyl isocyanate", 
//					  @"Isobutyl isocyanate", 
//					  @"Phenyl isocyanate", 
//					  @"Cyclohexyl isocyanate", 
//					  @"Iodine pentafluoride (when spilled in water)", 
//					  @"Diketene, stabilized", 
//					  @"Methylchlorosilane", 
//					  @"Chlorine pentafluoride", 
//					  @"Carbon monoxide and Hydrogen mixture", 
//					  @"Hydrogen and Carbon monoxide mixture", 
//					  @"Methoxymethyl isocyanate", 
//					  @"Methyl orthosilicate", 
//					  @"Methyl iodide", 
//					  @"Hexachlorocyclopentadiene", 
//					  @"Chloroacetonitrile", 
//					  @"Stibine", 
//					  @"Phosphorus pentabromide (when spilled in water)", 
//					  @"Boron tribromide (when spilled on land)", 
//					  @"Boron tribromide (when spilled in water)", 
//					  @"n-Propyl chloroformate", 
//					  @"sec-Butyl chloroformate", 
//					  @"Isobutyl chloroformate", 
//					  @"n-Butyl chloroformate", 
//					  @"Lithium nitride (when spilled in water)", 
//					  @"Buzz (when used as a weapon)", 
//					  @"BZ (when used as a weapon)", 
//					  @"CS (when used as a weapon)", 
//					  @"DC (when used as a weapon)", 
//					  @"GA (when used as a weapon)", 
//					  @"GB (when used as a weapon)", 
//					  @"GD (when used as a weapon)", 
//					  @"GF (when used as a weapon)", 
//					  @"H (when used as a weapon)", 
//					  @"HD (when used as a weapon)", 
//					  @"HL (when used as a weapon)", 
//					  @"HN-1 (when used as a weapon)", 
//					  @"HN-2 (when used as a weapon)", 
//					  @"HN-3 (when used as a weapon)", 
//					  @"L (Lewisite) (when used as a weapon)", 
//					  @"Lewisite (when used as a weapon)", 
//					  @"Mustard (when used as a weapon)", 
//					  @"Mustard Lewisite (when used as a weapon)", 
//					  @"Poisonous liquid, n.o.s.", 
//					  @"Poisonous liquid, organic, n.o.s.", 
//					  @"Liquefied gas, poisonous, n.o.s.", 
//					  @"Methanesulphonyl chloride", 
//					  @"Nitriles, poisonous, flammable, n.o.s.", 
//					  @"Nitriles, toxic, flammable, n.o.s.", 
//					  @"Nitriles, poisonous, liquid, n.o.s.", 
//					  @"Nitriles, poisonous, n.o.s.", 
//					  @"Nitriles, toxic, liquid, n.o.s.", 
//					  @"Nitriles, toxic, n.o.s.", 
//					  @"Organoarsenic compound, liquid, n.o.s.", 
//					  @"Organoarsenic compound, n.o.s.", 
//					  @"Metal carbonyls, liquid, n.o.s.", 
//					  @"Metal carbonyls, n.o.s.", 
//					  @"Poisonous liquid, inorganic, n.o.s.", 
//					  @"Compressed gas, toxic, corrosive, n.o.s.", 
//					  @"Liquefied gas, toxic, oxidizing, n.o.s.", 
//					  @"Methyl phosphonic dichloride", 
//					  @"Chloropivaloyl chloride", 
//					  @"3,5-Dichloro-2,4,6-trifluoropyridine", 
//					  @"Trimethoxysilane",
                      @"Flood Risk",
                      @"Hurricane",
					  nil];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.materials.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	NSString *materialStr = [self.materials objectAtIndex:indexPath.row];
	
    cell.textLabel.text = materialStr;
	
	if ([materialStr isEqualToString:self.currentMaterial]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Choose a material";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.currentMaterial = [self.materials objectAtIndex:indexPath.row];
	
	[self.delegate performSelector:self.didSelectMaterial withObject:self.currentMaterial afterDelay:0.0];
	
	[self dismissModalViewControllerAnimated:YES];
}


@end
