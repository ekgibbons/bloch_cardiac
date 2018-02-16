TARGET = bloch_cardiac

INSTALL_PATH = ~/python_utils/simulations

SRCDIR = src
OBJDIR = obj
BINDIR = bin

SOURCES   = $(wildcard $(SRCDIR)/*.c)
SOURCES_CPP = $(wildcard $(SRCDIR)/*.cpp)
INCUDES   = $(wildcard $(SRCDIR)/*.h)
INCUDES_HPP = $(wildcard $(SRCDIR)/*.hpp)
OBJECTS_C    = $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
OBJECTS_CPP  = $(SOURCES_CPP:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

# include base path
BASE_INCLUDE = /home/mirl/egibbons/.conda/envs/ekg/include

# library base path
BASE_LIB = /home/mirl/egibbons/.conda/envs/ekg/lib

# linear alebra libraries
LINALG_LIBS=-lopenblas -larmadillo

# location of the Python header files
PYTHON_VERSION = 3.5
PYTHON_INCLUDE = $(BASE_INCLUDE)/python$(PYTHON_VERSION)

# location of the Boost Python include files and library
# (this will vary based on what machine you are on, obviously)
BOOST_INC = $(BASE_INCLUDE)
BOOST_LIB = $(BASE_LIB)

# boost libraries
LIBRARY_PATH = -L$(BOOST_LIB)
PYTHON_LIBS = -lpython$(PYTHON_VERSION) -lboost_python -lboost_numpy 

LD_LIBS = $(PYTHON_LIBS) $(LINALG_LIBS)
CPPFLAGS = -O3 -Wall -Wconversion -fPIC 
CXXFLAGS = -std=c++11 -I$(PYTHON_INCLUDE) -I$(BOOST_INC)
# CFLAGS = 
LDFLAGS = -shared -Wl,--export-dynamic 
LDFLAGS += -Wl,--unresolved-symbols=report-all

.PHONY: all
all: $(TARGET) install # run

$(TARGET): $(OBJECTS_C) $(OBJECTS_CPP)
	$(CXX) $(LDFLAGS) $(OBJECTS_C) $(OBJECTS_CPP) $(LIBRARY_PATH) $(LD_LIBS) -o $(TARGET).so
	mv $(TARGET).so python/

$(OBJECTS_C): $(OBJDIR)/%.o : $(SRCDIR)/%.c
	$(CC) $(CPPFLAGS) -c -o $@ $< 

$(OBJECTS_CPP): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

.PHONY: install
install:
	cp python/$(TARGET).so $(INSTALL_PATH)

.PHONY: clean
clean:
	rm -rf *~ *.o *.so
	rm -rf $(OBJECTS_C)
	rm -rf $(OBJECTS_CPP)
	rm -rf $(TARGET).so
	rm -rf python/$(TARGET).so
	rm -rf python/*.pdf python/*.jpg python/*.png

